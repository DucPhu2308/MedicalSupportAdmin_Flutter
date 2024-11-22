import 'package:flutter/material.dart';
import 'package:bt_flutter/api/doctor_api.dart';

class PermissionDoctorScreen extends StatefulWidget {
  const PermissionDoctorScreen({super.key});

  @override
  State<PermissionDoctorScreen> createState() => _PermissionDoctorScreenState();
}

class _PermissionDoctorScreenState extends State<PermissionDoctorScreen> {
  List<dynamic> doctors = []; // Danh sách bác sĩ
  bool isLoading = true;
  String searchQuery = ''; // Query tìm kiếm
  String filterStatus = 'Tất cả'; // Trạng thái lọc

  @override
  void initState() {
    super.initState();
    _fetchDoctors(); // Gọi hàm lấy dữ liệu khi màn hình khởi tạo
  }

  Future<void> _fetchDoctors() async {
    try {
      final data = await DoctorApi.getAllDoctorInfo(); // Gọi API lấy danh sách bác sĩ
      setState(() {
        doctors = data;
        isLoading = false;
      });


    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch doctors: $e')),
      );
    }
  }

  Future<void> _grantPermission(String doctorId, int index) async {
    try {
      print (doctorId);
      // Cập nhật trạng thái "cấp quyền" qua API
      final result = await DoctorApi.grantDoctorPermission(doctorId);
      setState(() {
        // Cập nhật lại trạng thái của bác sĩ sau khi cấp quyền
        doctors[index]['doctorInfo']['isPermission'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission granted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to grant permission: $e')),
      );
    }
  }

  Future<void> _removePermission(String doctorId, int index) async {
    try {
      print(doctorId);
      // Cập nhật trạng thái "remove permission" qua API
      final result = await DoctorApi.removeDoctorPermission(doctorId);
      setState(() {
        // Cập nhật lại trạng thái của bác sĩ sau khi xóa quyền
        doctors[index]['doctorInfo']['isPermission'] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission removed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove permission: $e')),
      );
    }
  }

  List<dynamic> _filteredDoctors() {
    return doctors.where((doctor) {
      bool matchesSearch = doctor['firstName'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor['lastName'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          (doctor['firstName'] + ' ' + doctor['lastName']).toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesStatus = filterStatus == 'Tất cả' ||
          (filterStatus == 'Đã duyệt' && doctor['doctorInfo']['isPermission'] == true) ||
          (filterStatus == 'Chưa phê duyệt' && doctor['doctorInfo']['isPermission'] == false);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredDoctors = _filteredDoctors();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Cấp quyền bác sĩ'),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiện vòng tròn load khi đang tải
          : Column(
              children: [
                // Input tìm kiếm
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm bác sĩ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Select lọc theo trạng thái
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    value: filterStatus,
                    items: <String>['Tất cả', 'Đã duyệt', 'Chưa phê duyệt']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        filterStatus = value!;
                      });
                    },
                  ),
                ),
                // Hiển thị danh sách bác sĩ
                Expanded(
                  child: filteredDoctors.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = filteredDoctors[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ảnh đại diện
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(doctor['avatar'] ?? 'https://via.placeholder.com/150'),
                                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 12),
                                    // Thông tin bác sĩ
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor['firstName'] + ' ' + doctor['lastName'] ?? 'N/A',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text('Ngày sinh: ${DateTime.parse(doctor['dob']).day}/${DateTime.parse(doctor['dob']).month}/${DateTime.parse(doctor['dob']).year}'),
                                          const SizedBox(height: 4),
                                          Text('Số điện thoại: ${doctor['doctorInfo']['phone'] ?? 'N/A'}'),
                                          const SizedBox(height: 4),
                                          Text('Khoa: ${doctor['doctorInfo']['specialities']?.isNotEmpty == true ? doctor['doctorInfo']['specialities'][0]['name'] : 'N/A'}'),
                                        ],
                                      ),
                                    ),
                                    //Nút cấp quyền
                                    ElevatedButton(
                                      onPressed: doctor['doctorInfo']['isPermission'] == true
                                          ? () => _removePermission(doctor['_id'], index) // Nếu đã cấp quyền, nhấn vào sẽ xóa quyền
                                          : () => _grantPermission(doctor['_id'], index), // Nếu chưa cấp quyền, nhấn vào sẽ cấp quyền
                                      child: Text(
                                        doctor['doctorInfo']['isPermission'] == true
                                            ? 'Đã cấp quyền'
                                            : 'Cấp quyền',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('Không có bác sĩ')),
                ),
              ],
            ),
    );
  }
}
