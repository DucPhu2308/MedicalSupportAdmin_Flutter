import 'package:flutter/material.dart';
import '../api/department_api.dart';

class ManageDepartmentsPage extends StatefulWidget {
  const ManageDepartmentsPage({super.key});

  @override
  State<ManageDepartmentsPage> createState() => _ManageDepartmentsPageState();
}

class _ManageDepartmentsPageState extends State<ManageDepartmentsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  String removeDiacritics(String input) {
    const diacritics =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ'
        'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
    const nonDiacritics = 'aaaaaaaeeeeeeiiiiioooooooooooooouuuuuuuyyyyd'
        'AAAAAAEEEEEEIIIIIOOOOOOOOOOOOOOUUUUUUYYYYD';

    return input.split('').map((char) {
      final index = diacritics.indexOf(char);
      return index != -1 ? nonDiacritics[index] : char;
    }).join();
  }

  void _showNotification(String message,
      {bool isError = false, String? title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? (isError ? 'Lỗi' : 'Thành công'),
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Row(
            children: [
              Icon(
                isError ? Icons.error : Icons.check_circle,
                color: isError ? Colors.red : Colors.green,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _fetchDepartments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await DepartmentApi.getAllDepartments();
      setState(() {
        _departments = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching departments: $e");
      _showNotification('Lỗi khi tải danh sách khoa: $e', isError: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nhập tên khoa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isProcessing ? null : _addDepartment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                      ),
                      child: const Text('+ Thêm mới'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm tên khoa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Tên khoa')),
                              DataColumn(label: Text('Chức năng')),
                            ],
                            rows: List.generate(
                              _filteredDepartments().length,
                              (index) {
                                final dept = _filteredDepartments()[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(dept['name'])),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: _isProcessing
                                                ? null
                                                : () {
                                                    _editDepartment(
                                                        dept['_id']);
                                                  },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: _isProcessing
                                                ? null
                                                : () {
                                                    _confirmDelete(dept['_id']);
                                                  },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _addDepartment() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });
      try {
        await DepartmentApi.addDepartment(name);
        _nameController.clear();
        await _fetchDepartments();
        _showNotification('Thêm khoa thành công!');
      } catch (e) {
        _showNotification('Lỗi khi thêm khoa: $e', isError: true);
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _editDepartment(String id) {
    final department = _departments.firstWhere(
      (dept) => dept['_id'] == id,
      orElse: () => {},
    );
    if (department.isNotEmpty) {
      _nameController.text = department['name'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chỉnh sửa khoa'),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên khoa'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    setState(() {
                      _isProcessing = true;
                    });
                    try {
                      await DepartmentApi.updateDepartmentName(id, newName);
                      _nameController.clear();
                      await _fetchDepartments();
                      Navigator.pop(context);
                      _showNotification('Cập nhật khoa thành công!');
                    } catch (e) {
                      _showNotification('Lỗi khi cập nhật khoa: $e',
                          isError: true);
                    } finally {
                      setState(() {
                        _isProcessing = false;
                      });
                    }
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          );
        },
      );
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa khoa này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isProcessing = true;
                });
                try {
                  await _deleteDepartment(id);
                } finally {
                  setState(() {
                    _isProcessing = false;
                  });
                }
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDepartment(String id) async {
    try {
      await DepartmentApi.deleteDepartment(id);
      await _fetchDepartments();
      _showNotification('Xóa khoa thành công!');
    } catch (e) {
      _showNotification(e.toString(), isError: true);
    }
  }

  List<Map<String, dynamic>> _filteredDepartments() {
    final query = removeDiacritics(_searchController.text.trim().toLowerCase());
    if (query.isEmpty) {
      return _departments;
    }
    return _departments.where((dept) {
      final deptName = removeDiacritics((dept['name'] as String).toLowerCase());
      return deptName.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
