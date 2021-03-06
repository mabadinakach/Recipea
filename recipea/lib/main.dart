import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Recipea'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

class _MyHomePageState extends State<MyHomePage> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  int _counter = 0;
  bool isReplay = false;

  var randomRecipe = null;

  Future getRandomRecipe() async {
    var url = "https://api.spoonacular.com/recipes/random?limitLicense=true&number=10&apiKey=17aacff51e834c24acb4cd2dcdea4cce";
    await http.get(url).then((response) {
      var json1 = json.decode("[" + response.body + "]");
      setState(() {
        randomRecipe = json1[0];  
      });
      
    });

  }

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    if (isReplay) return [Post("Replaying !", "Replaying body")];
    if (text.length == 5) throw Error();
    if (text.length == 6) return [];
    List<Post> posts = [];

    var random = new Random();
    for (int i = 0; i < 100; i++) {
      posts.add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
    }
    return posts;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() { 
    super.initState();
    setState(() {
      for (var i = 0; i<100; i++) {
        list.add(Text(i.toString(), style: TextStyle(fontSize: 50), key: Key(i.toString()),));
      }
    });
    getRandomRecipe();
  }

  List<IconData> menu = [Icons.home, Icons.person, Icons.settings];

  List<Widget> list = [];

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter --;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SearchBar<Post>(
                              searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                              headerPadding: EdgeInsets.symmetric(horizontal: 10),
                              listPadding: EdgeInsets.symmetric(horizontal: 10),
                              onSearch: _getALlPosts,
                              searchBarController: _searchBarController,
                              emptyWidget: Text("empty"),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              onItemFound: (Post post, int index) {
                                return Container(
                                  color: Colors.red,
                                  child: ListTile(
                                    title: Text(post.title, style: TextStyle(color: Colors.white),),
                                    isThreeLine: true,
                                    subtitle: Text(post.body, style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Featured Recipes"),
                            ),
                            Container(
                              width: 800,
                              height: 200,
                              child:ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var i in list) Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 200,
                                      height: 100,
                                      color: Colors.blue,
                                      child: InkWell(
                                        child: Center(child: i),
                                        onTap: () {
                                          print(i.key);
                                        },
                                      )
                                    ),
                                  ),                
                                ],
                              ), 
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Categories"),
                            ),
                            Container(
                              width: 800,
                              height: 200,
                              child:ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var i in list) Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 200,
                                      height: 100,
                                      color: Colors.purple,
                                      child: InkWell(
                                        child: Center(child: i),
                                        onTap: () {
                                          print(i.key);
                                        },
                                      )
                                    ),
                                  ),                
                                ],
                              ), 
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Random Recipes"),
                            ),
                            randomRecipe == null ? CircularProgressIndicator() : Container(
                              width: 800,
                              height: 200,
                              child:ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var i = 0;i<randomRecipe["recipes"].length;i++) Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(randomRecipe["recipes"][i]["image"]))
                                      ),
                                      width: 300,
                                      height: 300,
                                      child: Center(
                                        child: InkWell(
                                          child: Container(
                                            height: 100,
                                            width: 200,
                                            color: Colors.grey.withOpacity(0.5),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  randomRecipe["recipes"][i]["title"], style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                                                  )
                                                ),
                                            )
                                            ),
                                          onTap: () {
                                            print(randomRecipe["recipes"][i]["title"]);
                                          },
                                        ),
                                      )
                                    ),
                                  ),                
                                ],
                              ), 
                            )
                          ],
                        )
                      ],
                    )
                  ),
                  
                  
                ],
              ),
            ),
          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}