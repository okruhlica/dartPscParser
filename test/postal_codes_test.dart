library change_set_test;

import 'package:unittest/unittest.dart';
import 'package:psc/psclib.dart';

void main() {
  group('(Change)', () {

    test('initialize.', () {

        PostalCodeImporter p = PostalCodeImporter.fromCsv('../data/13-11-2013/psc_obce.csv', '../data/13-11-2013/psc_ulice.csv',
            (x) {
              for (String key in x.items.keys) {
                var s = x.items[key].toString();
                print(s);
              }
              print(x.items.keys.length());
        });

    });
  });
}