import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel producto = new ProductoModel();
  final ProductosProvider productoProvider = new ProductosProvider();

  File foto;

  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null ){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget> [
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ), 
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ), 
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget> [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => producto.titulo = value,
      validator: ( valor ){
        if ( valor.length < 3 ){
          return 'Ingrese el nombre del producto.';
        }else{
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (valor) => producto.valor = double.parse(valor),
      validator: ( valor ){
        if ( utils.isNumeric(valor) ){
          return null;
        }else{
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      onPressed: (_guardando) ? null : _submit
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if ( !formKey.currentState.validate() ) return;
    setState(() {
      _guardando = true;
    });

    formKey.currentState.save();

    if ( foto != null ){
      producto.fotoUrl = await productoProvider.subirImagen( foto );
    }


    print('TODO OK');
    print( producto.titulo );
    print( producto.valor.toString() );
    print( producto.disponible );

    if ( producto.id == null ){
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    
    mostrarSnackBar("Registro guardado");

    setState(() {
      _guardando = false;
    });

    Navigator.pop(context);
  }

  void mostrarSnackBar (String mensaje) {
    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto(){
    if (producto.fotoUrl != null) {
 
      return Container();
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async{
    _procesarImagen( ImageSource.gallery );
  }

  _tomarFoto() async{
    _procesarImagen( ImageSource.camera );
  }

  _procesarImagen( ImageSource origen ) async {
    foto = await ImagePicker.pickImage(
      source: origen
    );

    if ( foto != null ){
      // limpieza
    }

    setState(() {
      
    });
  }
}