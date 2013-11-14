library change_set_test;

import 'package:unittest/unittest.dart';
import 'package:psc/psclib.dart';
import 'dart:async';
import 'dart:io';

void main() {

  group('(PostalCode)', () {

    test('Correct instantiation. (T01)', () {
        // when
        PostalCode code = new PostalCode('931 01', 'Šamorín', 'Dunajská Streda');

        // then
        expect(code.toString(), equals('931 01 (Šamorín / Dunajská Streda)'));
    });

    test('Corrected postal code format. (T02)', () {
      // when
      PostalCode code = new PostalCode('93101', 'Šamorín', 'Dunajská Streda');

      // then
      expect(code.toString(), equals('931 01 (Šamorín / Dunajská Streda)'));
    });

    test('Bad postal code format - too short. (T03)', () {
      // when, then
      expect(() => new PostalCode('9310', 'Šamorín', 'Dunajská Streda'), throwsA(new isInstanceOf<FormatException>()));
    });

    test('Bad postal code format - trailing spaces. (T04)', () {
      // when, then
      expect(() => new PostalCode('93101 ', 'Šamorín', 'Dunajská Streda'), throwsA(new isInstanceOf<FormatException>()));
    });

    test('Bad postal code format - empty string. (T05)', () {
      // when, then
      expect(() => new PostalCode('', 'Šamorín', 'Dunajská Streda'), throwsA(new isInstanceOf<FormatException>()));
    });

  });

  group('(PostalCodeImporter)', () {

    test('Postal codes correctly imported - random test. (T01)', () {
        var codesFuture = PostalCodeImporter.fromCsv(new File('../data/13-11-2013/psc_obce.csv'), new File('../data/13-11-2013/psc_ulice.csv'))
                                            .then((List<PostalCode> lst) => lst.map((PostalCode p) => p.toString()));

        expect(codesFuture, completion(contains('931 01 (Šamorín / Dunajská Streda)')));
        expect(codesFuture, completion(contains('957 01 (Bánovce nad Bebravou / Bánovce nad Bebravou)')));
    });


  });
}