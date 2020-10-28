import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  final String _url = "https://flutter-varios-10b77.firebaseio.com";
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto( ProductoModel producto ) async{
    final url = "$_url/Productos.json?auth=${ _prefs.token }";
    final resp = await http.post(url, body: productoModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;

  }

  Future<bool> editarProducto( ProductoModel producto ) async{
    final url = "$_url/Productos/${ producto.id }.json?auth=${ _prefs.token }";
    final resp = await http.put(url, body: productoModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;

  }

  Future<List<ProductoModel>> cargarProductos () async {
    final url = "$_url/Productos.json?auth=${ _prefs.token }";
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

  Future<int> borrarProducto(String id) async{
    final url = "$_url/Productos/$id.json?auth=${ _prefs.token }";
    final resp = await http.delete(url);
    print( json.decode(resp.body) );
    return 1;
  }

  Future<String> subirImagen( File imagen ) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/asalmerontkd/image/upload?upload_preset=yimvg8hc');
    final mimeType = mime( imagen.path ).split('/'); //imagen/jpeg

    final imageUploadReq = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadReq.files.add(file);

    final streamResponse = await imageUploadReq.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('Algo Salió mal');
      print( resp.body );
      return null;
    }

    final respData = json.decode( resp.body );
    print(respData);
    return respData['secure_url'];

  }
}