import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controller/bookmark_manager.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:recipe_app/views/detail_view_example.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkManager>(
      create: (context) => BookmarkManager(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Bookmark'),
          ),
          body: Consumer<BookmarkManager>(
            builder: (context, bookManager, child) {
              return FutureBuilder(
                  future: bookManager.getBookmarks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RecipeModel>?> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Failed to load recipes"),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        !snapshot.hasData) {
                      return Center(
                        child: Text("No recipeis added to bookmarks"),
                      );
                    } else if (snapshot.hasData) {
                      // TODO: Change this to a CArd
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            RecipeModel recipeModel = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetialViewExample(
                                        recipeModel: recipeModel),
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  recipeModel.image,
                                  height: 150,
                                ),
                              ),
                              title: Text(recipeModel.title),
                              subtitle: Text(recipeModel.category),
                              trailing: IconButton(
                                onPressed: () async {
                                  await bookManager.deleteBookmark(recipeModel);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            // return SizedBox(height: 10);
                            return Divider();
                          },
                          itemCount: snapshot.data!.length);
                    }
                    return Center(
                      child: Text("There's nothing here"),
                    );
                  });
            },
          )),
    );
  }
}
