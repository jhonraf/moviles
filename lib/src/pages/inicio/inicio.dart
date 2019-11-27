import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_format/date_format.dart';

class InicioPage extends StatefulWidget {
  InicioPage() : super();
 
  final String title = "Inicio";
 
  @override
  InicioPageState createState() => InicioPageState();
}

class InicioPageState extends State<InicioPage> {
  //
  CarouselSlider carouselSlider;
  int _current = 0;
  List imgList = [
    'https://newsweekespanol.com/wp-content/uploads/2019/01/buap.jpg',
    'https://www.poblanerias.com/wp-content/archivos/2016/09/Facultad-Ciencias-de-la-Computacion-3.jpg',
    'https://pueblaonline.com.mx/2015/portal/movil/media/k2/items/cache/55d391f4e5c63de7a5fd4a1040a67581_L.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlvCai5u5OMoPkOizL3YyOtetZq3EvMvelzApS6TBh1RKI4rDQdg&s',
    'https://www.buap.mx/sites/default/files/styles/interior_facultades/public/compu02.jpg?itok=M-iV7DOi'
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  DateTime _data = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          
          
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            carouselSlider = CarouselSlider(
              height: 300.0,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: true,
              reverse: false,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: imgList.map((imgUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(imgList, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.redAccent : Colors.blue,
                  ),
                );
              }),
              
            ),

            SizedBox(
              height: 20.0,
            ),  
            Container(
              
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '${formatDate(_data, [d, '-', MM, '-', yyyy])}',
                      style: new TextStyle(color: Colors.black),
                    ),
                    new Text('Curso: Inteligencia de negocios',
                      style: new TextStyle(color: Colors.black),
                    ),
                    new Text('09:00 a 10:59',
                      style: new TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 400,
              color: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    
                    new Text(
                      'NOTIFICACION',
                      style: new TextStyle(color: Colors.white),
                    ),
                  ],
                ),  
              ),
            ),
             
          ],
        ),
      ),
    );
  }
}