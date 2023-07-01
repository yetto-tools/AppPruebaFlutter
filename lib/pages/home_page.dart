import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1686041957371-1731140190a0?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4ODE5NTg2Mw&ixlib=rb-4.0.3&q=80&w=200', // Asegúrate de reemplazar estas URL con las URL de las imágenes que deseas usar.
    'https://images.unsplash.com/photo-1687428959667-369ef891658a?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4ODE5NTg5Nw&ixlib=rb-4.0.3&q=80&w=200',
    'https://images.unsplash.com/photo-1687428959667-369ef891658a?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4ODE5NTg5Nw&ixlib=rb-4.0.3&q=80&w=200',
    'https://plus.unsplash.com/premium_photo-1684407617180-02d36c20a687?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY4ODE5NTg3Mg&ixlib=rb-4.0.3&q=80&w=200',
  ];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["tablav"] ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Prestamos:'),
      ),
      body: _items.isNotEmpty
          ? ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(_items[index]['PRESTAMO']),
                  margin: const EdgeInsets.all(15.0),
                  color: Colors.cyan[100],
                  child: ListTile(
                    title: Text('Cliente: ${_items[index]['NOMBRE_CLIENTE']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prestamo: ${_items[index]['PRESTAMO']}'),
                        Text('DPI: ${_items[index]['DPI']}'),
                        Text('FUD: ${_items[index]['FUD_CLIENTE']}'),
                      ],
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(_items[index]['NOMBRE_CLIENTE']),
                              Text('Prestamo: ${_items[index]['PRESTAMO']}'),
                              Text('DPI: ${_items[index]['DPI']}'),
                              Text('FUD: ${_items[index]['FUD_CLIENTE']}'),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 200.0,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    viewportFraction: 0.8,
                                  ),
                                  items: imgList
                                      .map((item) => Container(
                                            child: Center(
                                                child: Image.network(item,
                                                    fit: BoxFit.cover,
                                                    width: 1000)),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
