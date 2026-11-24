import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gregorypoveda_leccion_6s1/main.dart';

void main() {
  testWidgets('muestra los cuatro datos al presionar el botón', (tester) async {
    await tester.pumpWidget(const RegistroPersonalApp());

    await tester.enterText(
      find.byKey(const Key('nombre')),
      'Ana María Pérez López',
    );
    await tester.enterText(
      find.byKey(const Key('direccion')),
      'Av. 25 de Julio',
    );
    await tester.enterText(find.byKey(const Key('fecha')), '14/03/1999');
    await tester.enterText(
      find.byKey(const Key('cargo')),
      'Asistente administrativo',
    );
    await tester.ensureVisible(find.text('MOSTRAR DATOS'));
    await tester.tap(find.text('MOSTRAR DATOS'));
    await tester.pump();

    expect(find.text('DATOS REGISTRADOS'), findsOneWidget);
    expect(
      find.textContaining('Nombre: Ana María Pérez López'),
      findsOneWidget,
    );
    expect(find.textContaining('Dirección: Av. 25 de Julio'), findsOneWidget);
    expect(find.textContaining('Nacimiento: 14/03/1999'), findsOneWidget);
    expect(
      find.textContaining('Cargo: Asistente administrativo'),
      findsOneWidget,
    );
  });
}
