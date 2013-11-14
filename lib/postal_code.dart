
part of postal_codes;

/**
 * Represents an area defined by a postal code with all relevant information.
 */
class PostalCode {

  final postalCodeMatcherWithSpace = new RegExp(r'(^[0-9]{3}\ [0-9]{2}$)');
  final postalCodeMatcherNoSpace = new RegExp(r'(^[0-9]{5}$)');
  String code, city, district;

  PostalCode(this.code, this.city, this.district) {
    code = _normalizeCodeFormat(code);
    if (!_verifyFormat(code)) {
      throw new FormatException("Malformed postal code: $code (context: $city, $district)");
    }
  }

  /**
   * Normalizes "DDDDD" postal code formats into "DDD DD"
   */
  String _normalizeCodeFormat(String code) {
    if (postalCodeMatcherWithSpace.firstMatch(code) == null &&
        postalCodeMatcherNoSpace.firstMatch(code) != null) {
      return code.substring(0, 3) + " " + code.substring(3);
    }
    return code;
  }

  bool _verifyFormat(String s) => postalCodeMatcherWithSpace.firstMatch(s) != null;

  String toString() => "$code ($city / $district)";
}


typedef void CsvLineHandler(List<String> columns);

/**
 * Parses a database of postal codes from a external sources.
 */
class PostalCodeImporter {

  /**
   * Uses 2 csv files exposed by Slovenska Posta for importing data. Both [csvCodesByTown] and
   * [csvCodesByStreet] files need to be UTF-8 encoded and columns comma-delimited.
   */
  static Future<List<PostalCode>> fromCsv(File csvCodesByTown, File csvCodesByStreet) {
    List<PostalCode> codes = new List<PostalCode>();

    void handleTownFileLine(List<String> columns) {
      var code = trim(columns[3]);
      if (code.length > 0) { // some lines contain no postal code, only a reference to the second file
        PostalCode postalCode = new PostalCode(code, columns[1], columns[2]);
        codes.add(postalCode);
      }
    }

    void handleStreetFileLine(List<String> columns) {
      var code = trim(columns[2]);
      if (code.length > 0) {
        PostalCode postalCode = new PostalCode(code, columns[6],columns[6]); // is this always true? Manual check would be nice.
        codes.add(postalCode);
      }
    }

    // parse input files one at a time
    return parseCsv(csvCodesByTown, handleTownFileLine)
            .then((_) => parseCsv(csvCodesByStreet, handleStreetFileLine))
            .then((_) => codes);
  }

  /**
   * Reads the .csv [file] line by line and applies [rowFunction] on each row of the file.
   */
  static Future parseCsv(File file, CsvLineHandler rowFunction, {int skipLines : 1}) {
    return file.readAsString()
               .then((text) {
                  text.split('\n')
                      .skip(skipLines)
                      .forEach((line) {
                        rowFunction(line.split(',').toList());
                      });
            });
  }
}
