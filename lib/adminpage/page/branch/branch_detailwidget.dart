import 'package:booking_haircut_application/adminpage/page/branch/branch_add_employeewidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_add_servicewidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_edit_servicewidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_editwidget.dart';
import 'package:booking_haircut_application/adminpage/page/employee/employee_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/config/photo_view.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/employeemodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BranchDetailwidget extends StatefulWidget {
  final Branch branch;

  const BranchDetailwidget({super.key, required this.branch});

  @override
  State<BranchDetailwidget> createState() => _BranchDetailwidgetState();
}

class _BranchDetailwidgetState extends State<BranchDetailwidget> {
  late Branch selectedBranch;
  String? _imagePath; // To store the image path

  @override
  void initState() {
    super.initState();
    selectedBranch = widget.branch;
    _imagePath = widget.branch.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBranchImage(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thông tin chi nhánh', style: headingStyle),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BranchEditwidget(branch: selectedBranch),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit_note_rounded),
                ),
              ],
            ),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            const SizedBox(height: 5),
            _buildDetailRow("Mã chi nhánh:", selectedBranch.id.toString()),
            _buildDetailRow("Tên chi nhánh:", selectedBranch.name),
            _buildDetailRow("Tên rút gọn:", selectedBranch.anothername),
            _buildDetailRow("Loại chi nhánh:",
                selectedBranch.type == 1 ? "Chi nhánh chính" : "Chi nhánh phụ"),
            _buildDetailRow("Địa chỉ chi nhánh:", selectedBranch.address),
            _buildEmployeeSection(),
            _buildServiceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchImage() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageZoomScreen(
                imagePath:
                    'assets/images/shop/${_imagePath}', // Use _imagePath here
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 170,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(202, 202, 204, 60),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: branchColor.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            // Display the image from JSON data
            image: _imagePath != null
                ? DecorationImage(
                    image: AssetImage('assets/images/shop/${_imagePath}'),
                    fit: BoxFit.cover,
                  )
                : null, // No image if _imagePath is null
          ),
          // If there's no image, show the add icon
          child: _imagePath == null
              ? const Icon(Icons.add_a_photo_outlined)
              : null,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(title, style: subtitleDetailStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '', // Handle null values
              style: infoDetailStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Nhân viên chi nhánh', style: headingStyle),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Pass the selectedBranch to BranchAddEmployeeWidget
                    builder: (context) =>
                        BranchAddEmployeeWidget(branch: selectedBranch),
                  ),
                ).then((_) {
                  // Refresh the branch details after adding an employee
                  setState(() {
                    selectedBranch = widget.branch; // Reload data
                  });
                });
              },
              icon: const Icon(Icons.add_circle_outline_outlined),
              iconSize: 25,
              color: branchColor,
            ),
          ],
        ),
        const Divider(
          color: branchColor,
          height: 1,
          thickness: 2,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const DottedLine(
            dashColor: branchColor20,
            dashLength: 5,
            dashGapLength: 2,
            dashRadius: 8,
          ),
          itemCount: selectedBranch.employees?.length ?? 0,
          itemBuilder: (context, index) {
            final employee = selectedBranch.employees?[index];
            return ListTile(
              key: ValueKey(employee?.id),
              onTap: () {
                if (employee != null) {
                  // Check if employee is not null
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // Pass the employee object from the list
                      builder: (BuildContext context) => EmployeeDetailwidget(
                        employee: employee, // Pass the Employee object
                      ),
                    ),
                  );
                }
              },
              minTileHeight: 10,
              title: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('${index + 1}', style: serialStyle),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(employee?.nickname ?? '', style: infoListStyle),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(selectedBranch.anothername ?? '',
                        style: labelStyle),
                  ),
                  const Spacer(),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _deleteEmployee(employee);
                      },
                      child: const Icon(
                        Icons.do_not_disturb_on_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _deleteEmployee(Employee? employeeDelete) {
    setState(() {
      selectedBranch.employees!.remove(employeeDelete);
    });
  }

  Widget _buildServiceSection() {
    // Group services by type
    Map<String, List<Service>> servicesByType = {};
    for (var service in selectedBranch.services!) {
      if (servicesByType.containsKey(service.type)) {
        servicesByType[service.type]!.add(service);
      } else {
        servicesByType[service.type!.toString()] = [service];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Dịch vụ cung cấp', style: headingStyle),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BranchAddServiceWidget(
                      branch: selectedBranch,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_outlined),
              iconSize: 25,
              color: branchColor,
            ),
          ],
        ),
        const Divider(
          color: branchColor,
          height: 1,
          thickness: 2,
        ),
        const SizedBox(
          height: 16,
        ),
        // Display services grouped by type
        ...servicesByType.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key, // Service type (e.g., "CẮT-GỘI-CẠO")
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const DottedLine(
                  dashColor: branchColor20,
                  dashLength: 5,
                  dashGapLength: 2,
                  dashRadius: 8,
                ),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final service = entry.value[index];
                  return ListTile(
                    key: ValueKey(service.name),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BranchEditServiceWidget(
                                  service: service,
                                ))),
                    minTileHeight: 10,
                    title: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('${index + 1}', style: serialStyle),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text('${service.name}', style: infoListStyle),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                              NumberFormat("#,### đ").format(service.price),
                              style: infoListStyle3),
                        ),
                        const Spacer(),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _deleteService(service);
                            },
                            child: const Icon(
                              Icons.do_not_disturb_on_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        })
      ],
    );
  }

  void _deleteService(Service serviceDelete) {
    setState(() {
      selectedBranch.services!.remove(serviceDelete);
    });
  }
}
