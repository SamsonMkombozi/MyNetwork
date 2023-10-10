import 'package:flutter/material.dart';
import 'package:mynetwork/db/employee.dart';
import 'local.dart';

class DataTableScreen extends StatefulWidget {
  DataTableScreen({required Key key}) : super(key: key);

  @override
  _DataTableScreenState createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  late List<Employee> _employees;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  late Employee _selectedEmployee;
  bool _isUpdating = false;
  String _titleProgress = 'Employee List';

  @override
  void initState() {
    super.initState();
    _employees = [];
    _loadEmployees();
  }

  _loadEmployees() {
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees.cast<Employee>();
      });
    });
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _addEmployee() {
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty) {
      Services.addEmployee(_firstNameController.text, _lastNameController.text)
          .then((result) {
        if (result == 'success') {
          _clearValues();
          _loadEmployees();
          _showSnackBar('Employee added successfully');
        }
      });
    }
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        _showSnackBar(result);
        _getEmployees();
      }
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees.cast<Employee>();
      });
      // _showProgress(widget.title);
      print("Length: ${employees.length}");
    });
  }

  _updateEmployee() {
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty) {
      Services.UpdateEmployee(_selectedEmployee.id as int,
              _firstNameController.text, _lastNameController.text)
          .then((result) {
        if (result == 'success') {
          setState(() {
            _isUpdating = false;
          });
          _clearValues();
          _loadEmployees();
          _showSnackBar('Employee updated successfully');
        }
      });
    }
  }

  _deleteEmployee(Employee employee) {
    Services.deleteEmployee(employee.id as int).then((result) {
      if (result == 'success') {
        _loadEmployees();
        _showSnackBar('Employee deleted successfully');
      }
    });
  }

  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _firstNameController,
              decoration: InputDecoration.collapsed(
                hintText: 'First Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _lastNameController,
              decoration: InputDecoration.collapsed(
                hintText: 'Last Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isUpdating ? _updateEmployee : _addEmployee,
            child: Text(_isUpdating ? 'Update' : 'Add Employee'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${_employees[index].firstName} ${_employees[index].lastName}'),
                  onTap: () {
                    setState(() {
                      _selectedEmployee = _employees[index];
                      _firstNameController.text = _selectedEmployee.firstName;
                      _lastNameController.text = _selectedEmployee.lastName;
                      _isUpdating = true;
                    });
                  },
                  onLongPress: () {
                    _deleteEmployee(_employees[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
