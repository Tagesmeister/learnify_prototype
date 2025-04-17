import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnify_prototype/Data/DataHandler.dart';
import 'package:learnify_prototype/Data/SessionModel.dart';

class AddSessionDynamic extends StatefulWidget {
  const AddSessionDynamic(this.isSave, this.id, {super.key});

  final bool isSave;
  final String id;

  @override
  State<AddSessionDynamic> createState() => _AddSessionDynamicState();
}

class _AddSessionDynamicState extends State<AddSessionDynamic> {
  bool _isBookSelected = true;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Book-Felder
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookChapterController = TextEditingController();
  final TextEditingController _bookPageController = TextEditingController();

  // Web-Felder
  final TextEditingController _webNameController = TextEditingController();
  final TextEditingController _webUrlController = TextEditingController();

  late int currentSessionIndex;

  @override
  void initState() {
    super.initState();
    _dateController.text = _getCurrentDate();

    // Wird Ausgeführt, wenn man am Bearbeiten ist.
    if (!widget.isSave) {
      var (data, index) = DataHandler.getCurrentSession(widget.id);
      currentSessionIndex = index;

      _subjectController.text = data.subject;
      var (year, month, day) = getParseDate(data.date);

      _dateController.text = '${year}-${month}-${day}';
      _timeController.text = data.plannedTime;

      if (data.isBook) {
        _bookNameController.text = data.sourceString[0];
        _bookChapterController.text = data.sourceInt[0].toString();
        _bookPageController.text = data.sourceInt[1].toString();
      }
      //Überprüft ob man web als Source in der Daten abgespeichert hat.
      else if (!data.isBook) {
        _isBookSelected = false;

        _webNameController.text = data.sourceString[0];
        _webUrlController.text = data.sourceString[1];
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _dateController.dispose();
    _timeController.dispose();

    _bookNameController.dispose();
    _bookChapterController.dispose();
    _bookPageController.dispose();

    _webNameController.dispose();
    _webUrlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session hinzufügen'),
        backgroundColor: const Color(0xFFAED79F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Subject
            _buildInputContainer(
              label: 'Subject:',
              hintText: 'z. B. Mathematik',
              controller: _subjectController,
            ),
            const SizedBox(height: 10),

            // Date
            _buildInputContainer(
              label: 'Date:',
              hintText: '',
              controller: _dateController,
            ),
            const SizedBox(height: 10),

            // Time
            _buildInputContainer(
              label: 'Time:',
              hintText: 'z. B. 12:00',
              controller: _timeController,
            ),
            const SizedBox(height: 10),

            // Source-Auswahl (Book / Web)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDFEBDA),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 60,
                    child: Text(
                      'Source:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  ToggleButtons(
                    isSelected: [_isBookSelected, !_isBookSelected],
                    onPressed: (int index) {
                      setState(() {
                        _isBookSelected = (index == 0);
                      });
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    fillColor: Colors.lightGreen.shade200,
                    selectedColor: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Book'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Web'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Dynamische Felder je nach Auswahl
            if (_isBookSelected) ...[
              _buildInputContainer(
                label: 'Name:',
                hintText: 'z. B. Buchtitel',
                controller: _bookNameController,
              ),
              const SizedBox(height: 10),
              _buildInputContainer(
                label: 'Chapter:',
                hintText: 'z. B. Kapitel 3',
                controller: _bookChapterController,
              ),
              const SizedBox(height: 10),
              _buildInputContainer(
                label: 'Page:',
                hintText: 'z. B. Seite 45',
                controller: _bookPageController,
              ),
            ] else ...[
              _buildInputContainer(
                label: 'Web-Name:',
                hintText: 'z. B. Tutorial-Seite',
                controller: _webNameController,
              ),
              const SizedBox(height: 10),
              _buildInputContainer(
                label: 'URL:',
                hintText: 'z. B. https://...',
                controller: _webUrlController,
              ),
            ],
            const SizedBox(height: 10),

            // Beispielhafter "Absenden"-Button
            ElevatedButton(
              onPressed: () {
                // Variablen füllen
                final subject = _subjectController.text;
                final dateStr = _dateController.text;
                final timeStr = _timeController.text;

                // Wir bauen source als Liste aus den dynamischen Feldern
                List<String> source = [];
                List<int?> sourceInt = [];
                if (_isBookSelected) {
                  source.add(_bookNameController.text);
                  sourceInt.add(int.tryParse(_bookChapterController.text));
                  sourceInt.add(int.tryParse(_bookPageController.text));
                } else {
                  source.add(_webNameController.text);
                  source.add(_webUrlController.text);
                }

                // Datum/Zeit parsen
                // Du musst dieses Format anpassen, falls deine Strings anders aussehen
                // z.B. 12-4-2025 => "yyyy-MM-dd" Formate
                // Hier nur als Beispiel:
                // Wir versuchen ein Datum in Format dd-mm-yyyy

                final (day, month, year) = getParseDate(dateStr);
                final parsedDate = '${day}-${month}-${year}';

                final (hour, minute) = getParseTime(timeStr);
                final parsedTime = '${hour}:${minute}';

                final bool isBook = _isBookSelected;

                SessionModel sessionModel = SessionModel(
                  subject,
                  parsedDate,
                  source,
                  sourceInt,
                  parsedTime,
                  isBook,
                );

                if (widget.isSave) {
                  // In DB speichern
                  DataHandler.storeDatainHive(sessionModel);
                  messageUser("saved!");
                }
                if (widget.isSave == false) {
                  SessionModel sessionModelCurrentData = SessionModel(
                    subject,
                    parsedDate,
                    source,
                    sourceInt,
                    parsedTime,
                    isBook,
                  );

                  DataHandler.updateDatainHive(
                    currentSessionIndex,
                    sessionModelCurrentData,
                  );
                  messageUser("updated!");
                  // https://chatgpt.com/share/67fd9442-788c-8001-9909-d3e1e95a6181
                }
              },
              child: Text(_getButtonName()),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonName() {
    if (widget.isSave == true) {
      return 'Save';
    } else if (widget.isSave == false) {
      return 'Update';
    }

    return 'Error';
  }

  void messageUser(message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$message')));
  }

  /// Hilfsfunktion, um ein einheitliches Container-Layout für Textfelder zu erzeugen.
  Widget _buildInputContainer({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDFEBDA),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(0, 3), color: Colors.black26),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (int, int, int) getParseDate(String dateStr) {
    final dateParts = dateStr.split('-');
    final year = int.tryParse(dateParts[0]) ?? 1;
    final month = int.tryParse(dateParts[1]) ?? 1;
    final day = int.tryParse(dateParts[2]) ?? 2000;
    return (day, month, year);
  }

  (int, int) getParseTime(String timeStr) {
    final timeParts = timeStr.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    return (hour, minute);
  }

  /// Beispielmethode, um das aktuelle Datum in Format "dd-mm-yyyy" zurückzugeben.
  String _getCurrentDate() {
    var now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }
}
