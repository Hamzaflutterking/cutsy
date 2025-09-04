import 'dart:async';
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/services/Exceptions/app_exceptions.dart';

class BarberSearchController extends GetxController {
  // Search state
  final isSearching = false.obs;
  final searchError = RxnString();
  final searchResults = <BarberData>[].obs;
  final searchQuery = ''.obs;

  // Recent searches
  final recentSearches = <String>[].obs;

  // Popular searches
  final popularSearches = <String>['Hair Cutting', 'Hair Extensions', 'Hair Styling', 'Hair Coloring', 'Beard Trimming', 'Hair Treatment'].obs;

  // Debounce timer for search
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  // Main search function
  Future<void> searchBarbers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      searchError.value = null;
      searchQuery.value = '';
      return;
    }

    searchQuery.value = query;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query);
    });
  }

  // Perform actual search API call using existing endpoint
  Future<void> _performSearch(String query) async {
    try {
      isSearching.value = true;
      searchError.value = null;

      apiService.setToken(StorageService.to.getString("token") ?? "");

      // Use the existing search endpoint with query parameter
      final response = await apiService.request("${ApiConfig.userShowBarbersBySearch}?search=${Uri.encodeComponent(query.trim())}", method: "GET");

      // Parse the response - it should match BarberModel structure
      final parsed = BarberModel.fromJson(Map<String, dynamic>.from(response));
      searchResults.assignAll(parsed.data ?? []);

      // Add to recent searches if we got results
      if (searchResults.isNotEmpty) {
        _addToRecentSearches(query.trim());
      }
    } on NotFoundException {
      searchResults.clear();
      searchError.value = "No barbers found for '$query'";
    } catch (e) {
      searchResults.clear();
      searchError.value = "Search failed: ${e.toString()}";
      showCustomSnackbar(title: "Search Error", message: e.toString());
    } finally {
      isSearching.value = false;
    }
  }

  // Search by service (use same endpoint)
  Future<void> searchByService(String serviceName) async {
    await searchBarbers(serviceName);
  }

  // Clear search results
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    searchError.value = null;
    _debounceTimer?.cancel();
  }

  // Add to recent searches
  void _addToRecentSearches(String query) {
    // Remove if already exists
    recentSearches.remove(query);
    // Add to beginning
    recentSearches.insert(0, query);
    // Keep only last 10 searches
    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }
    _saveRecentSearches();
  }

  // Remove from recent searches
  void removeFromRecent(String query) {
    recentSearches.remove(query);
    _saveRecentSearches();
  }

  // Clear all recent searches
  void clearRecentSearches() {
    recentSearches.clear();
    _saveRecentSearches();
  }

  // Save recent searches to local storage
  void _saveRecentSearches() {
    StorageService.to.setStringList('recent_searches', recentSearches);
  }

  // Load recent searches from local storage
  void _loadRecentSearches() {
    final saved = StorageService.to.getStringList('recent_searches');
    recentSearches.assignAll(saved);
  }

  // Filter by rating
  void filterByRating(double minRating) {
    if (searchResults.isEmpty) return;

    final filtered = searchResults.where((barber) {
      return (barber.averageRating ?? 0.0) >= minRating;
    }).toList();

    searchResults.assignAll(filtered);
  }

  // Sort results
  void sortResults(String sortBy) {
    if (searchResults.isEmpty) return;

    switch (sortBy) {
      case 'rating':
        searchResults.sort((a, b) => (b.averageRating ?? 0.0).compareTo(a.averageRating ?? 0.0));
        break;
      case 'name':
        searchResults.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
      case 'distance':
        showCustomSnackbar(title: "Sort", message: "Distance sorting requires location access");
        break;
    }
  }
}
