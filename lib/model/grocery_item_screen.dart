import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open/components/grocery_tile.dart';
import 'package:open/model/grocery_item.dart';
import 'package:uuid/uuid.dart';
import 'fooderlich_pages.dart';

class GroceryItemScreen extends StatefulWidget {
  static MaterialPage page({
    Function(GroceryItem)? onCreate,
    Function(GroceryItem)? onUpdate,
    GroceryItem? item,
  }) {
    return MaterialPage(
      name: FooderlichPages.groceryItemDetails,
      key: ValueKey(FooderlichPages.groceryItemDetails),
      child: GroceryItemScreen(
        onCreate: onCreate,
        onUpdate: onUpdate,
        originalItem: item,
      ),
    );
  }

  final Function(GroceryItem)? onCreate;
  final Function(GroceryItem)? onUpdate;

  final GroceryItem? originalItem;

  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    this.onCreate,
    this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() {
    return _GroceryItemScreenState();
  }
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    if (widget.originalItem != null) {
      _nameController.text = widget.originalItem?.name ?? "";
      _name = widget.originalItem?.name ?? "";
      _currentSliderValue = widget.originalItem?.quantity ?? 0;
      _importance = widget.originalItem?.importance ?? Importance.low;
      _currentColor = widget.originalItem?.color ?? Colors.green;
      final date = widget.originalItem?.date;
      if (date != null) {
        _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
        _dueDate = date;
      }
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                final groceryItem = GroceryItem(
                  id: widget.originalItem?.id ?? const Uuid().v1(),
                  name: _nameController.text,
                  importance: _importance,
                  color: _currentColor,
                  quantity: _currentSliderValue,
                  date: DateTime(
                    _dueDate.year,
                    _dueDate.month,
                    _dueDate.day,
                    _timeOfDay.hour,
                    _timeOfDay.minute,
                  ),
                );
                if (widget.isUpdating) {
                  if (widget.onUpdate != null) widget.onUpdate!(groceryItem);
                } else {
                  if (widget.onCreate != null) widget.onCreate!(groceryItem);
                }
              }),
        ],
        elevation: 0.0,
        title: Text(
          'Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildNameField(),
            const SizedBox(height: 10.0),
            _buildImportantField(),
            const SizedBox(height: 10.0),
            _buildDateField(),
            const SizedBox(height: 10.0),
            _buildTimeField(),
            const SizedBox(height: 10.0),
            _buildColorField(),
            const SizedBox(height: 10.0),
            _buildQuantityField(),
            GroceryTile(
              item: GroceryItem(
                  name: _name,
                  importance: _importance,
                  color: _currentColor,
                  date: DateTime(_dueDate.year, _dueDate.month, _dueDate.day,
                      _timeOfDay.hour, _timeOfDay.minute),
                  quantity: _currentSliderValue),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      children: [
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28.0),
        ),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildImportantField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Importance",
          style: GoogleFonts.lato(fontSize: 28),
        ),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
                selectedColor: Colors.black,
                label: const Text(
                  "low",
                  style: TextStyle(color: Colors.white),
                ),
                onSelected: (selected) {
                  setState(() {
                    _importance = Importance.low;
                  });
                },
                selected: _importance == Importance.low),
            ChoiceChip(
                selectedColor: Colors.black,
                label: const Text(
                  "medium",
                  style: TextStyle(color: Colors.white),
                ),
                onSelected: (selected) {
                  setState(() {
                    _importance = Importance.medium;
                  });
                },
                selected: _importance == Importance.medium),
            ChoiceChip(
                selectedColor: Colors.black,
                label: const Text(
                  "high",
                  style: TextStyle(color: Colors.white),
                ),
                onSelected: (selected) {
                  setState(() {
                    _importance = Importance.high;
                  });
                },
                selected: _importance == Importance.high)
          ],
        )
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date",
              style: GoogleFonts.lato(fontSize: 28),
            ),
            TextButton(
                onPressed: () async {
                  final currentDate = DateTime.now();
                  final selectDate = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: currentDate,
                      lastDate: DateTime(currentDate.year + 5));

                  setState(() {
                    if (selectDate != null) _dueDate = selectDate;
                  });
                },
                child: const Text("select"))
          ],
        ),
        if (_dueDate != null)
          Text('${DateFormat("yyyy-MM-dd").format(_dueDate)}')
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Time",
              style: GoogleFonts.lato(fontSize: 28),
            ),
            TextButton(
                onPressed: () async {
                  final selectTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  setState(() {
                    if (selectTime != null) _timeOfDay = selectTime;
                  });
                },
                child: const Text("select")),
          ],
        ),
        if (_timeOfDay != null) Text("${_timeOfDay.format(context)}")
      ],
    );
  }

  Widget _buildColorField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 50,
              color: _currentColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Color",
              style: GoogleFonts.lato(fontSize: 28),
            )
          ],
        ),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: BlockPicker(
                        onColorChanged: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                        },
                        pickerColor: Colors.white,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("save"))
                      ],
                    );
                  });
            },
            child: Text(
              "select",
            ))
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              "Quantity",
              style: GoogleFonts.lato(fontSize: 28),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              _currentSliderValue.toInt().toString(),
              style: GoogleFonts.lato(fontSize: 16),
            )
          ],
        ),
        Slider(
            value: _currentSliderValue.toDouble(),
            max: 100,
            min: 0,
            divisions: 100,
            activeColor: _currentColor,
            inactiveColor: _currentColor.withOpacity(0.5),
            label: _currentSliderValue.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value.toInt();
              });
            })
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
