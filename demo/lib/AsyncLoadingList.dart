import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:raisedbutton_sample/ShoppingListApp.dart';



/// the app to use
class AsyncLoadingListApp extends StatelessWidget {
  static State<_AsyncLoadingList> state;
  @override
  Widget build(BuildContext context) {
    return _AsyncLoadingList();
  }
}

/// the stateful list
class _AsyncLoadingList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    final state = _AsyncLoadingListState();
    AsyncLoadingListApp.state = state;
    return state;
  }
}

/// state
class _AsyncLoadingListState extends State<_AsyncLoadingList> {
  final pageSize = 20;

  bool _isLoading = false;

  var _products = <_Product>[];

  var _selected = Set<_Product>();

  @override
  void initState() {
    super.initState();
//    AsyncLoadingListApp.state.setState(() {
//      _isLoading = true;
//    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: _getBody(),
      backgroundColor: Colors.lightBlue[50],
    );
  }

  String _getTitle() => _isLoading ? 'Loading...' : 'Product List';

  /// returns the body of scaffold
  Widget _getBody() {
    if (_isLoading) {
      return _buildLoadingBody();
    } else {
      if (_products.length == 0) {
        return _buildEmptyBody();
      } else {
        return _buildListView();
      }
    }
  }

  /// 加载中样式
  Widget _buildLoadingBody() {
    return Container(
      height: 300.0,
      child: Center(
        child: CupertinoActivityIndicator(animating: true),
      ),
    );
  }

  /// 空列表样式
  Widget _buildEmptyBody() {
    return Center(
      child: Container(
          width: 150,
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                child: Image.asset('images/gray_dinosaur.png'),
              ),
              RaisedButton(
                child: Text('Reload'),
                color: Colors.red,
                onPressed: () {
                  _loadData();
                },
              ),
            ],
          )
      ),
    );
  }

  /// 商品列表
  Widget _buildListView() {
    return ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: _products.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }
          final index = i ~/ 2;
          final product = _products[index];
          return _buildRow(product, _selected.contains(product));
        });
  }

  /// 单个商品展示
  Widget _buildRow(_Product product, bool selected) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        child: Image.network(product.imageUrl, fit: BoxFit.fill),
      ),
      title: Text(product.name),
      subtitle: Text('￥${product.price}   库存：${product.stock}'),
      trailing: Checkbox(
        value: selected,
        onChanged: (selected) {
          if (selected) {
            setState(() {
              _selected.add(product);
            });
          } else {
            setState(() {
              _selected.remove(product);
            });
          }
        },
      ),
      onTap: () {
        _launch(product.url);
      },
    );
  }

  /// 在浏览器打开网址
  void _launch(String url) async {
    print('Openning: $url');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// 加载数据
  void _loadData() async {
    String dataURL = 'https://mall.huishoubao.com/product/lists';
    setState(() {
      _isLoading = true;
      _products = <_Product>[];
    });
    try {
      http.Response response = await http.post(
          dataURL,
          body: {
            'pageIndex': '0',
            'pageSize': '$pageSize',
            'isDiffSpu': '1'
          });
      _parseResponse(response.body);
    } catch (identifier) {
      print('catch: $identifier');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 解析数据，更新 state
  void _parseResponse(String resp) {
    final decoded = json.decode(resp);
    final exception = Exception('解析失败');
    final list = decoded['_data']['list'];
    if (list == null) {
      throw exception;
    }
    var products = <_Product>[];
    for (int i = 0; i < list.length; i++) {
      final item = list[i];
      final product = _Product.fromJson(item);
      if (product != null) {
        products.add(product);
      }
    }

    setState(() {
      _products = products;
    });
  }
}

/// 商品
class _Product {
  _Product({this.name, this.url, this.imageUrl, this.price, this.stock})
      : assert(name != null && url != null && imageUrl != null && price != null && stock != null);
  final String name;
  final String url;
  final String price;
  final String imageUrl;
  final String stock;

  factory _Product.fromJson(Map<String, dynamic>json) => _productFromJson(json);

  static _Product _productFromJson(Map<String, dynamic> json) {
    return _Product(
      name: json['fullName'] as String,
      url: json['url'] as String,
      imageUrl: json['image'] as String,
      price: json['salesPriceYuan'] as String,
      stock: json['stock'] as String,
    );
  }
}