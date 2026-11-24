import 'package:flutter/material.dart';

// Punto de entrada de la aplicación.
void main() {
  runApp(const RegistroPersonalApp());
}

// Configuración general: tema, título y pantalla inicial.
class RegistroPersonalApp extends StatelessWidget {
  const RegistroPersonalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empresa XYZ · Registro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C6B43)),
        useMaterial3: true,
      ),
      home: const RegistroPersonalScreen(),
    );
  }
}

// StatefulWidget permite actualizar el resultado sin abrir otra pantalla.
class RegistroPersonalScreen extends StatefulWidget {
  const RegistroPersonalScreen({super.key});

  @override
  State<RegistroPersonalScreen> createState() => _RegistroPersonalScreenState();
}

class _RegistroPersonalScreenState extends State<RegistroPersonalScreen> {
  static const Color verde = Color(0xFF1C6B43);

  // Cada campo tiene un controlador para leer el texto que escribió el usuario.
  final TextEditingController _ctrlNombre = TextEditingController();
  final TextEditingController _ctrlDireccion = TextEditingController();
  final TextEditingController _ctrlFecha = TextEditingController();
  final TextEditingController _ctrlCargo = TextEditingController();

  // Empieza vacío; al pulsar el botón contendrá los datos del formulario.
  String _datosMostrados = '';

  @override
  void dispose() {
    // Liberamos los controladores cuando esta pantalla deja de existir.
    _ctrlNombre.dispose();
    _ctrlDireccion.dispose();
    _ctrlFecha.dispose();
    _ctrlCargo.dispose();
    super.dispose();
  }

  // El calendario facilita ingresar una fecha, aunque también se puede escribir.
  Future<void> _elegirFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona la fecha de nacimiento',
    );
    if (fecha == null || !mounted) return;

    _ctrlFecha.text =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  void _mostrarDatos() {
    // Leemos y limpiamos los espacios de los cuatro campos.
    final String nombre = _ctrlNombre.text.trim();
    final String direccion = _ctrlDireccion.text.trim();
    final String fecha = _ctrlFecha.text.trim();
    final String cargo = _ctrlCargo.text.trim();

    if (nombre.isEmpty || direccion.isEmpty || fecha.isEmpty || cargo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los cuatro campos.')),
      );
      return;
    }

    // setState avisa a Flutter que debe volver a dibujar el resultado.
    setState(() {
      _datosMostrados =
          'Nombre: $nombre\n'
          'Dirección: $direccion\n'
          'Nacimiento: $fecha\n'
          'Cargo: $cargo';
    });
    FocusScope.of(context).unfocus();
  }

  // Construye un campo con etiqueta visible y borde similar al ejemplo.
  Widget _campo({
    required String etiqueta,
    required String ejemplo,
    required TextEditingController controlador,
    required String clave,
    TextInputType teclado = TextInputType.text,
    Widget? icono,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 5),
          TextField(
            key: Key(clave),
            controller: controlador,
            keyboardType: teclado,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: ejemplo,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              suffixIcon: icono,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa XYZ · Registro'),
        backgroundColor: verde,
        foregroundColor: Colors.white,
      ),
      // El desplazamiento evita que el teclado tape los campos en teléfonos pequeños.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _campo(
                etiqueta: 'Nombre completo',
                ejemplo: 'Ej.: Ana María Pérez López',
                controlador: _ctrlNombre,
                clave: 'nombre',
                teclado: TextInputType.name,
              ),
              _campo(
                etiqueta: 'Dirección',
                ejemplo: 'Ej.: Av. 25 de Julio y Río Jaramijó',
                controlador: _ctrlDireccion,
                clave: 'direccion',
                teclado: TextInputType.streetAddress,
              ),
              _campo(
                etiqueta: 'Fecha de nacimiento',
                ejemplo: 'dd/mm/aaaa',
                controlador: _ctrlFecha,
                clave: 'fecha',
                teclado: TextInputType.datetime,
                icono: IconButton(
                  tooltip: 'Elegir fecha',
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: _elegirFecha,
                ),
              ),
              _campo(
                etiqueta: 'Cargo',
                ejemplo: 'Ej.: Asistente administrativo',
                controlador: _ctrlCargo,
                clave: 'cargo',
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _mostrarDatos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('MOSTRAR DATOS'),
                ),
              ),
              const SizedBox(height: 18),
              if (_datosMostrados.isEmpty)
                Container(
                  height: 94,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F5),
                    border: Border.all(color: const Color(0xFFE5E5E0)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Aquí se mostrarán los datos\nal presionar el botón',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F4EC),
                    border: Border.all(color: verde),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DATOS REGISTRADOS',
                        style: TextStyle(
                          color: verde,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _datosMostrados,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
