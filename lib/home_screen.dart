import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfbclone/update_screen.dart';
import 'package:flutterfbclone/user_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'authentication_bloc/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String userUid;
  UserRepository userRepository;

  HomeScreen({Key key, @required this.userUid, this.userRepository})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore firestore = Firestore.instance;
  bool likePost = false;
  int likeCount = 0;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
        title: Text(
          'Facebook',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FlatButton(
              color: Colors.black87,
              shape: StadiumBorder(),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Clone Mode',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          popupMenuButton()
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset(
                      'assets/images/encrypt.webp',
                      fit: BoxFit.cover,
                      height: 100.0,
                    )),
              ),
              title: OutlineButton(
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpdateScreen()));
                },
                child: Text(
                  'Write Something',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey[450]),
                ),
              ),
            ),
            StreamBuilder(
              stream: firestore.collection("posts").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircleAvatar(
                      radius: 20.5,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                return Expanded(
                  child: ListView(
                    children: snapshot.data.documents.map((document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.network(
                                        document['avatar'],
                                        fit: BoxFit.cover,
                                        height: 120.0,
                                      ),
                                    )),
                                title: Text(
                                  document['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  document['time'],
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  document['post'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    //height: 300.0,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Image.network(
                                            document['image'],
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          likePost = !likePost;
                                          if (likeCount == 0) {
                                            return likeCount = 1;
                                          } else if (likeCount == 1) {
                                            return likeCount = 0;
                                          }
                                          return null;
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            likePost
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: likePost
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          SizedBox(width: 5.0),
                                          Text(
                                            '$likeCount likes',
                                            style: TextStyle(
                                              color: likePost
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: OutlineButton(
                                        shape: StadiumBorder(),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  SingleChildScrollView(
                                                    child: Container(
                                                      color: Color(0xFF737373),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    15.0),
                                                          ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                        ),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(),
                                                                  title: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Name'),
                                                                      SizedBox(
                                                                          width:
                                                                              15.0),
                                                                      Text(
                                                                        '4 hours ago',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle: Text(
                                                                      'Full Comment Here'),
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(),
                                                                  title: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Name'),
                                                                      SizedBox(
                                                                          width:
                                                                              15.0),
                                                                      Text(
                                                                        '4 hours ago',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle: Text(
                                                                      'Full Comment Here'),
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(),
                                                                  title: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Name'),
                                                                      SizedBox(
                                                                          width:
                                                                              15.0),
                                                                      Text(
                                                                        '4 hours ago',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle: Text(
                                                                      'Full Comment Here'),
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(),
                                                                  title: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Name'),
                                                                      SizedBox(
                                                                          width:
                                                                              15.0),
                                                                      Text(
                                                                        '4 hours ago',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle: Text(
                                                                      'Full Comment Here'),
                                                                ),
                                                                Flexible(
                                                                  fit: FlexFit
                                                                      .loose,
                                                                  child: Align(
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomCenter,
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 5.0),
                                                                            child:
                                                                                TextField(
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.all(5.0),
                                                                                hintText: 'Write Comments',
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(30.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        IconButton(
                                                                          icon:
                                                                              FaIcon(FontAwesomeIcons.paperPlane),
                                                                          onPressed:
                                                                              () {},
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    ),
                                                  )

//                                                ListView(
//                                              children: <Widget>[
//                                                Container(
//                                                  color: Color(0xFF737373),
//                                                  child: Container(
//                                                    decoration: BoxDecoration(
//                                                      color: Theme.of(context)
//                                                          .canvasColor,
//                                                      borderRadius:
//                                                          BorderRadius.only(
//                                                        topLeft:
//                                                            Radius.circular(
//                                                                15.0),
//                                                        topRight:
//                                                            Radius.circular(
//                                                                15.0),
//                                                      ),
//                                                    ),
//                                                    child: Column(
//                                                      mainAxisSize:
//                                                          MainAxisSize.min,
//                                                      children: <Widget>[
//                                                        Container(
//                                                          alignment: Alignment
//                                                              .centerLeft,
//                                                          child: Padding(
//                                                            padding:
//                                                                const EdgeInsets
//                                                                    .all(
//                                                              15.0,
//                                                            ),
//                                                            child: Text(
//                                                              'Comments',
//                                                              textAlign:
//                                                                  TextAlign
//                                                                      .start,
//                                                              style: TextStyle(
//                                                                fontWeight:
//                                                                    FontWeight
//                                                                        .bold,
//                                                                fontSize: 15.0,
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ),
//                                                        ListTile(
//                                                          leading:
//                                                              CircleAvatar(),
//                                                          title: Row(
//                                                            mainAxisSize:
//                                                                MainAxisSize
//                                                                    .min,
//                                                            children: <Widget>[
//                                                              Text('Name'),
//                                                              SizedBox(
//                                                                  width: 12.0),
//                                                              Text(
//                                                                '4 hours ago',
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontSize:
//                                                                      10.0,
//                                                                  color: Colors
//                                                                      .grey,
//                                                                ),
//                                                              )
//                                                            ],
//                                                          ),
//                                                          subtitle: Text(
//                                                              'Full comments will appear here again and again as long as the comments keep popping and the internet never goes down day and night.'),
//                                                        ),
//                                                        ListTile(
//                                                          leading:
//                                                              CircleAvatar(),
//                                                          title: Row(
//                                                            mainAxisSize:
//                                                                MainAxisSize
//                                                                    .min,
//                                                            children: <Widget>[
//                                                              Text('Name'),
//                                                              SizedBox(
//                                                                  width: 12.0),
//                                                              Text(
//                                                                '4 hours ago',
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontSize:
//                                                                      10.0,
//                                                                  color: Colors
//                                                                      .grey,
//                                                                ),
//                                                              )
//                                                            ],
//                                                          ),
//                                                          subtitle: Text(
//                                                              'Full comments will appear here again and again as long as the comments keep popping and the internet never goes down day and night.'),
//                                                        ),
//                                                        ListTile(
//                                                          leading:
//                                                              CircleAvatar(),
//                                                          title: Row(
//                                                            mainAxisSize:
//                                                                MainAxisSize
//                                                                    .min,
//                                                            children: <Widget>[
//                                                              Text('Name'),
//                                                              SizedBox(
//                                                                  width: 12.0),
//                                                              Text(
//                                                                '4 hours ago',
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontSize:
//                                                                      10.0,
//                                                                  color: Colors
//                                                                      .grey,
//                                                                ),
//                                                              )
//                                                            ],
//                                                          ),
//                                                          subtitle: Text(
//                                                              'Full comments will appear here again and again as long as the comments keep popping and the internet never goes down day and night.'),
//                                                        ),
//                                                        Flexible(
//                                                          fit: FlexFit.loose,
//                                                          child: Align(
//                                                            alignment:
//                                                                FractionalOffset
//                                                                    .bottomCenter,
//                                                            child: Padding(
//                                                              padding:
//                                                                  const EdgeInsets
//                                                                          .all(
//                                                                      15.0),
//                                                              child: Row(
//                                                                mainAxisSize:
//                                                                    MainAxisSize
//                                                                        .min,
//                                                                children: <
//                                                                    Widget>[
//                                                                  Expanded(
//                                                                    child:
//                                                                        Padding(
//                                                                      padding: const EdgeInsets
//                                                                              .only(
//                                                                          left:
//                                                                              5.0),
//                                                                      child:
//                                                                          TextField(
//                                                                        decoration:
//                                                                            InputDecoration(
//                                                                          contentPadding:
//                                                                              EdgeInsets.all(5.0),
//                                                                          hintText:
//                                                                              'Write Comments',
//                                                                          border:
//                                                                              OutlineInputBorder(
//                                                                            borderRadius:
//                                                                                BorderRadius.circular(30.0),
//                                                                          ),
//                                                                        ),
//                                                                      ),
//                                                                    ),
//                                                                  ),
//                                                                  IconButton(
//                                                                    icon: FaIcon(
//                                                                        FontAwesomeIcons
//                                                                            .paperPlane),
//                                                                    onPressed:
//                                                                        () {},
//                                                                  )
//                                                                ],
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        )
//                                                      ],
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
                                              );
                                        },
                                        child: Text(
                                          'Write Comment',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.grey[450]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class popupMenuButton extends StatelessWidget {
  const popupMenuButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.black87),
      elevation: 20.0,
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'logout',
          child: Text('Log Out'),
        )
      ],
      onSelected: (value) {
        if (value == 'logout') {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedOut());
        }
      },
    );
  }
}
