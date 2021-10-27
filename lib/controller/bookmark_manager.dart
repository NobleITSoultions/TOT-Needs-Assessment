import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/service/bookmark_recipe.dart';
// import 'package:recipe_app/service/bookmark_manager.dart';

class BookmarkManager with ChangeNotifier {
  BookmarkManager();

  BookmarkService bookmarkService = BookmarkService();

  Future<List<RecipeModel>?> getBookmarks() async {
    try {
      await bookmarkService.open();
      List<RecipeModel>? recipies = await bookmarkService.getAllRecipe();
      if (recipies != null) {
        notifyListeners();
        await bookmarkService.close();
        return recipies;
      }
      return null;
    } catch (error) {
      await bookmarkService.close();
      print("Something went wrong fetching recipies $error");
      return throw error;
    }
  }

  Future<RecipeModel?> saveBookmark(RecipeModel recipeModel) async {
    try {
      await bookmarkService.open();
      RecipeModel recipe = await bookmarkService.insert(recipeModel);
      print('Added to boomarks: ${recipe.toJson()}');
      await getBookmarks();
      toast(msg: "Added to bookmarks");
      await bookmarkService.close();
      return recipe;
    } catch (error) {
      await bookmarkService.close();
      print("Something went wrong adding recipies $error");
      return null;
    }
  }

  Future<int> deleteBookmark(RecipeModel recipeModel) async {
    try {
      await bookmarkService.open();
      int deleteCount = await bookmarkService.delete(recipeModel.id!);
      print('Deleted $deleteCount recipies from boomarks');
      await getBookmarks();
      toast(msg: "Removed from bookmarks");
      await bookmarkService.close();
      return deleteCount;
    } catch (error) {
      await bookmarkService.close();
      print("Something went wrong adding recipies $error");
      return 0;
    }
  }
}

void toast({required String msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      fontSize: 16.0);
}
