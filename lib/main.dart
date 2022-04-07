import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(home: TrenbeApp(), debugShowCheckedModeBanner: false));
}

class TrenbeApp extends StatefulWidget {
  TrenbeApp({Key? key}) : super(key: key);
  var isNavBarHidden;
  var data;
  final controller = ScrollController();

  @override
  State<TrenbeApp> createState() => _TrenbeAppState();
}

class _TrenbeAppState extends State<TrenbeApp> {
  final GlobalKey<_MainBodyState> _mainBodyState = GlobalKey<_MainBodyState>();
  final GlobalKey<_MainBottomAppBarState> _mainNavBarState =
      GlobalKey<_MainBottomAppBarState>();

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
    } else if (status.isDenied) {
      print("거절됨");
      Permission.contacts.request();
      openAppSettings();
    }
  }

  setIsNavBarHidden(TF) {
    setState(() {
      widget.isNavBarHidden = TF;
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    // if (result.statusCode == 200) {
    // } else {}
    var result2 = jsonDecode(result.body);
    setState(() {
      widget.data = result2;
    });
  }

  getAdditionalData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    // if (result.statusCode == 200) {
    // } else {}
    var result2 = jsonDecode(result.body);
    setState(() {
      widget.data = [...widget.data, result2];
    });
  }

  scrollToTop() {
    setState(() {
      widget.controller.jumpTo(0);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    widget.isNavBarHidden = false;
    getData();

    widget.controller.addListener(() {
      if (widget.controller.position.pixels ==
          widget.controller.position.maxScrollExtent) {
        getAdditionalData();

        // widget.controller.jumpTo(widget.controller.position.pixels - 1);
      } else if (widget.controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setIsNavBarHidden(true);
      } else {
        setIsNavBarHidden(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MainAppBar(
          getAdditionalData: getAdditionalData,
          trenbeContext: context,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.expand_less_outlined,
          color: Colors.black,
          size: 50,
        ),
        onPressed: () {
          scrollToTop();
        },
      ),
      body: MainBody(
        key: _mainBodyState,
        hide_navbar_function: setIsNavBarHidden,
        controller: widget.controller,
        data: widget.data,
      ),
      bottomNavigationBar: MainBottomAppBar(
          key: _mainNavBarState, isNavBarHidden: widget.isNavBarHidden),
    );
  }
}

class MainAppBar extends StatelessWidget {
  MainAppBar({Key? key, this.getAdditionalData, this.trenbeContext})
      : super(key: key);

  var getPermission;
  final getAdditionalData;
  final trenbeContext;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
          padding: EdgeInsets.only(left: 15),
          child: Image.asset(
            "assets/title_text.png",
            scale: 1.5,
          )),
      actions: [
        IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.push(trenbeContext,
                  MaterialPageRoute(builder: (c) => UploadPage()));
              getAdditionalData();
            },
            icon: Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.black,
            )),
        IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border_outlined,
              color: Colors.black,
            )),
        IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            )),
      ],
    );
  }
}

class MainBody extends StatefulWidget {
  MainBody({Key? key, this.hide_navbar_function, this.data, this.controller})
      : super(key: key);
  var hide_navbar_function;
  var data;
  final controller;

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final image_list = [
    "assets/menu_items/menu_item_1.png",
    "assets/menu_items/menu_item_2.png",
    "assets/menu_items/menu_item_3.png",
    "assets/menu_items/menu_item_4.png",
    "assets/menu_items/menu_item_5.png",
    "assets/menu_items/menu_item_6.png",
    "assets/menu_items/menu_item_7.png",
    "assets/menu_items/menu_item_8.png",
    "assets/menu_items/menu_item_9.png",
    "assets/menu_items/menu_item_10.png"
  ];
  final title_list = [
    "여성",
    "남성",
    "키즈",
    "리세일",
    "아울렛",
    "하이엔드",
    "컨템럭셔리",
    "스니커즈",
    "홈리빙",
    "리퍼브"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: widget.controller,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              MainSearchBar(),
              MainTabBar(),
              MainCarouselSlider(),
              MainMenuLayout(
                image_list: image_list,
                title_list: title_list,
              ),
              ShopItemLayout(
                  scroll_controller: widget.controller,
                  hide_navbar_function: widget.hide_navbar_function,
                  data: widget.data),
            ],
          ),
        ));
  }
}

class MainSearchBar extends StatelessWidget {
  const MainSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
                fillColor: Color(0xF8F8F8),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.search, size: 30),
                ), //검색 아이콘 추가
                contentPadding:
                    EdgeInsets.only(left: 20, bottom: 0, top: 0, right: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: '트렌비X삼성전자 최대 20%쿠폰!'),
          ),
        ));
  }
}

class MainTabBar extends StatefulWidget {
  MainTabBar({Key? key}) : super(key: key);

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  final item_list = ["홈", "기획전", "랭킹", "브랜드", "IT:EM", "매거진"];
  var item_clicked_index = 0;

  setClickedIndex(index) {
    setState(() {
      item_clicked_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        MainTabItem(
            item_text: item_list[0],
            index: 0,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
        MainTabItem(
            item_text: item_list[1],
            index: 1,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
        MainTabItem(
            item_text: item_list[2],
            index: 2,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
        MainTabItem(
            item_text: item_list[3],
            index: 3,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
        MainTabItem(
            item_text: item_list[4],
            index: 4,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
        MainTabItem(
            item_text: item_list[5],
            index: 5,
            item_clicked_index: item_clicked_index,
            set_index_function: setClickedIndex),
      ]),
    );
  }
}

class MainTabItem extends StatefulWidget {
  MainTabItem(
      {Key? key,
      this.item_text,
      this.index,
      this.item_clicked_index,
      this.set_index_function})
      : super(key: key);

  final item_text;
  final index;
  final item_clicked_index;
  final set_index_function;

  @override
  State<MainTabItem> createState() => _MainTabItemState();
}

class _MainTabItemState extends State<MainTabItem> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextButton(
          onPressed: () {
            widget.set_index_function(widget.index);
          },
          child: Text(
            widget.item_text,
            style: TextStyle(
              color: widget.item_clicked_index == widget.index
                  ? Colors.black
                  : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          )),
    );
  }
}

class MainCarouselSlider extends StatefulWidget {
  const MainCarouselSlider({Key? key}) : super(key: key);

  @override
  State<MainCarouselSlider> createState() => _MainCarouselSliderState();
}

class _MainCarouselSliderState extends State<MainCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        // enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.amber),
                child: Container(
                  child: Image.asset(
                    "assets/carousel_item_" + i.toString() + ".png",
                    fit: BoxFit.cover,
                  ),
                ));
          },
        );
      }).toList(),
    );
  }
}

class MainMenuLayout extends StatelessWidget {
  const MainMenuLayout({Key? key, this.image_list, this.title_list})
      : super(key: key);

  final image_list;
  final title_list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(children: [
        Row(
          children: [
            MainMenuItem(image: image_list[0], title: title_list[0]),
            MainMenuItem(image: image_list[1], title: title_list[1]),
            MainMenuItem(image: image_list[2], title: title_list[2]),
            MainMenuItem(image: image_list[3], title: title_list[3]),
            MainMenuItem(image: image_list[4], title: title_list[4]),
          ],
        ),
        Row(
          children: [
            MainMenuItem(image: image_list[5], title: title_list[5]),
            MainMenuItem(image: image_list[6], title: title_list[6]),
            MainMenuItem(image: image_list[7], title: title_list[7]),
            MainMenuItem(image: image_list[8], title: title_list[8]),
            MainMenuItem(image: image_list[9], title: title_list[9]),
          ],
        )
      ]),
    );
  }
}

class MainMenuItem extends StatelessWidget {
  const MainMenuItem({Key? key, this.image, this.title}) : super(key: key);

  final image;
  final title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Wrap(children: [
          FlatButton(
            hoverColor: Color(0xFFFFFF),
            // highlightColor: Color(0xFFFFFF),
            disabledColor: Color(0xFFFFFF),
            focusColor: Color(0xFFFFFF),
            // splashColor: Color(0xFFFFFF),
            onPressed: () {},
            child: Column(children: [
              Image.asset(
                image,
                width: 50,
                height: 50,
              ),
              Text(title),
            ]),
          ),
        ]),
      ),
    );
  }
}

class MainBottomAppBar extends StatefulWidget {
  MainBottomAppBar({Key? key, this.isNavBarHidden}) : super(key: key);

  var item_clicked_index = 2;
  var isNavBarHidden;

  @override
  State<MainBottomAppBar> createState() => _MainBottomAppBarState();
}

class _MainBottomAppBarState extends State<MainBottomAppBar> {
  final icon_list = [
    Icons.grid_view_outlined,
    Icons.card_giftcard_outlined,
    Icons.home_outlined,
    Icons.shopping_bag_outlined,
    Icons.person_outlined,
  ];

  final title_list = ["카테고리", "이벤트", "홈", "뉴 시즌", "마이"];

  set_index_function(index) {
    setState(() {
      widget.item_clicked_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: widget.isNavBarHidden ? 0 : 70,
        child: SingleChildScrollView(
            child: BottomAppBar(
          child: Row(
            children: [
              MainBottomAppBarItem(
                  icon: icon_list[0],
                  title: title_list[0],
                  index: 0,
                  item_clicked_index: widget.item_clicked_index,
                  set_index_function: set_index_function),
              MainBottomAppBarItem(
                  icon: icon_list[1],
                  title: title_list[1],
                  index: 1,
                  item_clicked_index: widget.item_clicked_index,
                  set_index_function: set_index_function),
              MainBottomAppBarItem(
                  icon: icon_list[2],
                  title: title_list[2],
                  index: 2,
                  item_clicked_index: widget.item_clicked_index,
                  set_index_function: set_index_function),
              MainBottomAppBarItem(
                  icon: icon_list[3],
                  title: title_list[3],
                  index: 3,
                  item_clicked_index: widget.item_clicked_index,
                  set_index_function: set_index_function),
              MainBottomAppBarItem(
                  icon: icon_list[4],
                  title: title_list[4],
                  index: 4,
                  item_clicked_index: widget.item_clicked_index,
                  set_index_function: set_index_function),
            ],
          ),
        )));
  }
}

class MainBottomAppBarItem extends StatelessWidget {
  const MainBottomAppBarItem(
      {Key? key,
      this.icon,
      this.title,
      this.index,
      this.item_clicked_index,
      this.set_index_function})
      : super(key: key);

  final icon;
  final title;
  final item_clicked_index;
  final index;
  final set_index_function;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Wrap(children: [
          FlatButton(
            hoverColor: Color(0xFFFFFF),
            // highlightColor: Color(0xFFFFFF),
            disabledColor: Color(0xFFFFFF),
            focusColor: Color(0xFFFFFF),
            // splashColor: Color(0xFFFFFF),
            onPressed: () {
              set_index_function(index);
            },
            child: Column(children: [
              Icon(icon,
                  size: 30,
                  color: item_clicked_index == index
                      ? Colors.purple
                      : Colors.grey),
              Text(title,
                  style: TextStyle(
                      color: item_clicked_index == index
                          ? Colors.purple
                          : Colors.grey)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class ShopItemLayout extends StatefulWidget {
  ShopItemLayout(
      {Key? key, this.scroll_controller, this.hide_navbar_function, this.data})
      : super(key: key);

  var data;
  var isScrollReverse = false;
  var scroll_controller;
  var hide_navbar_function;

  @override
  State<ShopItemLayout> createState() => _ShopItemLayoutState();
}

class _ShopItemLayoutState extends State<ShopItemLayout> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: widget.data.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
          childAspectRatio: 0.75, //item 의 가로 1, 세로 2 의 비율
        ),
        itemBuilder: (c, i) {
          return ShopItem(image_url: widget.data[i]['image']);
        },
      );
    } else {
      return Text("로딩중");
    }
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({Key? key, this.image_url}) : super(key: key);

  final image_url;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
        ),
        padding: EdgeInsets.all(1),
        child: Column(
          children: [
            Image.network(
              image_url,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [Icon(Icons.shop), Text("상품 목록")],
              ),
            )
          ],
        ));
  }
}

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("이미지 업로드 화면"),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_outlined))
          ],
        ));
  }
}
