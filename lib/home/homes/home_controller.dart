// home/home_controller.dart
import 'package:cutcy/constants/helper.dart';
import 'package:cutcy/home/homes/barber_model.dart';
import 'package:cutcy/home/homes/favs/fav_barber_model.dart';
import 'package:cutcy/main.dart';
import 'package:cutcy/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:cutcy/services/api_configs.dart';
import 'package:cutcy/services/Exceptions/app_exceptions.dart';

class HomeController extends GetxController {
  // Trending
  final isLoading = false.obs;
  final error = RxnString();
  final barbers = <BarberData>[].obs;

  // Nearest
  final nearestLoading = false.obs;
  final nearestError = RxnString();
  final nearestBarbers = <BarberData>[].obs;
  List<BarberData> get nearestTop3 => nearestBarbers.length > 3 ? nearestBarbers.sublist(0, 3) : nearestBarbers;

  // ===== Favorites =====
  final favoritesLoading = false.obs;
  final favoritesError = RxnString();
  final favoriteBarbers = <FavBarberData>[].obs;

  // Derived “sets” for quick lookups and per-item spinner
  final favoriteIds = <String>{}.obs; // contains barber IDs
  final favBusy = <String>{}.obs; // ids currently being poste
  bool isFavorite(String? barberId) => barberId != null && favoriteIds.contains(barberId);
  // Home feed: show max 3 favorites
  List<FavBarberData> get favoritesTop3 => favoriteBarbers.length > 3 ? favoriteBarbers.sublist(0, 3) : favoriteBarbers;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingBarbers();
    fetchNearestBarbers();
    fetchFavoriteBarbers();
  }

  /// One function to fetch trending barbers and update state.
  Future<void> fetchTrendingBarbers() async {
    isLoading.value = true;
    error.value = null;
    apiService.setToken(StorageService.to.getString("token") ?? "");
    try {
      final res = await apiService.request(
        ApiConfig.userShowTrendingBarbers, // GET /user/homefeed/showTrendingBarbers
        method: "GET",
      );
      final parsed = BarberModel.fromJson(Map<String, dynamic>.from(res));
      barbers.assignAll(parsed.data ?? []);
    } on NotFoundException {
      // 404 => show empty state
      barbers.clear();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// ONE function to fetch nearest barbers and update state (404 => empty)
  Future<void> fetchNearestBarbers() async {
    nearestLoading.value = true;
    nearestError.value = null;
    apiService.setToken(StorageService.to.getString("token") ?? "");
    try {
      final res = await apiService.request(ApiConfig.userShowNearestBarbers, method: "GET");
      final parsed = BarberModel.fromJson(Map<String, dynamic>.from(res));
      nearestBarbers.assignAll(parsed.data ?? []);
    } on NotFoundException {
      nearestBarbers.clear(); // treat 404 as "no nearby"
    } catch (e) {
      nearestError.value = e.toString();
    } finally {
      nearestLoading.value = false;
    }
  }

  Future<void> fetchFavoriteBarbers() async {
    favoritesLoading.value = true;
    favoritesError.value = null;
    apiService.setToken(StorageService.to.getString("token") ?? "");
    try {
      final res = await apiService.request(ApiConfig.userShowBarberFavouriteList, method: "GET");
      final parsed = FavBarberModel.fromJson(res);
      favoriteBarbers.assignAll(parsed.data ?? []);
    } on NotFoundException {
      favoriteBarbers.clear(); // 404 => empty list
    } catch (e) {
      favoritesError.value = e.toString();
    } finally {
      favoritesLoading.value = false;
    }
  }

  // ---- FAVORITE a barber (POST) ----
  Future<void> addFavoriteBarber(String barberId) async {
    if (favBusy.contains(barberId)) return; // prevent double taps
    favBusy.add(barberId);
    apiService.setToken(StorageService.to.getString("token") ?? "");
    try {
      await apiService.request(ApiConfig.userSaveBarberInFavoriteList(barberId), method: "POST");
      // Refresh favorites from server so Home & Favorites screens reflect
      await fetchFavoriteBarbers();
      // Optional: toast
      showCustomSnackbar(title: "Favorites", message: "Added to favorites");
    } on UnauthorizedException catch (e) {
      showCustomSnackbar(title: "Auth", message: e.toString());
    } on NotFoundException catch (e) {
      showCustomSnackbar(title: "Not Found", message: e.toString());
    } catch (e) {
      showCustomSnackbar(title: "Error", message: e.toString());
    } finally {
      favBusy.remove(barberId);
    }
  }

  Future<void> refreshFavorites() => fetchFavoriteBarbers();
  Future<void> refreshNearest() => fetchNearestBarbers();
  Future<void> refreshTrending() => fetchTrendingBarbers();
}
