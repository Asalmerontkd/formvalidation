import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = "https://flutter-varios-10b77.firebaseio.com";

  Future<bool> crearProducto( ProductoModel producto ) async{
    final url = "$_url/Productos.json";
    final resp = await http.post(url, body: productoModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;

  }

  Future<List<ProductoModel>> cargarProductos () async {
    final url = "$_url/Productos.json";
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    
    if ( decodedData == null ) return [];
    final List<ProductoModel> productos = new List();

    decodedData.forEach((id, producto) {
      print(producto);
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    print(productos);
    return productos;
  }
}