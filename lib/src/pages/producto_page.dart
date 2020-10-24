import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  ProductoModel producto = new ProductoModel();
  final ProductosProvider productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if( prodData != null ){
      producto = prodData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget> [
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ), 
            onPressed: () {}
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ), 
            onPressed: () {}
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
      onPressed: _submit
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

  void _submit(){
    if ( !formKey.currentState.validate() ) return;
    formKey.currentState.save();


    print('TODO OK');
    print( producto.titulo );
    print( producto.valor.toString() );
    print( producto.disponible );

    if ( producto.id == null ){
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    
  }
}