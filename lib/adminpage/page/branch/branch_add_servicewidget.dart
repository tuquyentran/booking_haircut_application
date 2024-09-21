import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:booking_haircut_application/data/provider/serviceprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BranchAddServiceWidget extends StatefulWidget {
  final Branch branch;

  const BranchAddServiceWidget({super.key, required this.branch});

  @override
  State<BranchAddServiceWidget> createState() => _BranchAddServiceWidgetState();
}

class _BranchAddServiceWidgetState extends State<BranchAddServiceWidget> {
  List<Service> allServices = [];
  List<Service> filteredServices = [];
  List<Service> selectedService = [];

  late Future<List<Service>> listService;

  @override
  void initState() {
    super.initState();
    try {
      listService = ReadDataService().loadData().then((allServices) {
        setState(() {
          this.allServices = allServices;
          _filteredServices();
        });
        return allServices;
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  void _filteredServices() {
    filteredServices = allServices; // No need to filter allServices
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thêm dịch vụ', style: headingStyle),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceSection(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: buttonForServiceStyle(),
                        child: const Text(
                          'Xác nhận thêm dịch vụ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    // Group services by type
    Map<String, List<Service>> servicesByType = {};
    for (var service in filteredServices) {
      if (servicesByType.containsKey(service.type)) {
        servicesByType[service.type]!.add(service);
      } else {
        servicesByType[service.type!.toString()] = [service];
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  bool isServiceAdded = widget.branch.services!.any(
                      (existingService) => existingService.id == service.id);
                  return ListTile(
                    key: ValueKey(service.name),
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
                              style: infoListStyle2),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (isServiceAdded) {
                                _removeServiceFromBranch(service);
                              } else {
                                _addServiceToBranch(service);
                              }
                            },
                            child: Icon(
                              isServiceAdded
                                  ? Icons.do_not_disturb_on_outlined
                                  : Icons.add_circle_outline_outlined,
                              color: isServiceAdded ? Colors.red : branchColor,
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
        }),
      ],
    );
  }

// Add a service to the branch's service list
  void _addServiceToBranch(Service service) {
    setState(() {
      widget.branch.services!.add(service);
      selectedService.add(service);
    });
  }

  // Remove a service from the branch's service list
  void _removeServiceFromBranch(Service service) {
    setState(() {
      widget.branch.services!.remove(service);
      selectedService.remove(service);
    });
  }
}
