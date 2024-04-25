class ReportData {
  static var _report = [];

  void addReport(String question, bool correct) {
    _report.add({"question": question, "correct": correct});
  }

  List getReport() {
    return _report;
  }

  void deleteReport() {
    _report.clear();
  }
}
