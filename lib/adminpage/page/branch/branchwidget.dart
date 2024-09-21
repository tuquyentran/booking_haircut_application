import 'package:booking_haircut_application/adminpage/page/branch/branch_addwidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_deletewidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/provider/branchprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class Branchwidget extends StatefulWidget {
  const Branchwidget({super.key});

  @override
  State<Branchwidget> createState() => _BranchwidgetState();
}

class _BranchwidgetState extends State<Branchwidget> {
  final controller = TextEditingController();
  List<Branch> branches = [];
  List<Branch> filteredBranches = [];
  late Future<List<Branch>> listBranch;

  @override
  void initState() {
    super.initState();
    try {
      listBranch = ReadDataBranch().loadData().then((branches) {
        setState(() {
          this.branches = branches;
          filteredBranches = branches;
        });
        return branches;
      });
    } catch (e) {
      print('Error in initState: $e'); // Output error to the console
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: branchColor),
                ),
              ),
              onChanged: searchBranch,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  "Danh sách các chi nhánh",
                  style: headingStyle,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BranchAddWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline_outlined),
                  iconSize: 25,
                  color: branchColor,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BranchDeleteWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline_outlined),
                  iconSize: 25,
                  color: branchColor,
                ),
              ],
            ),
            const Divider(
              color: branchColor,
              height: 10,
              thickness: 2,
            ),
            Expanded(
              child: FutureBuilder<List<Branch>>(
                future: listBranch,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No branches found.'));
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const DottedLine(
                        dashColor: branchColor20,
                        dashLength: 5,
                        dashGapLength: 2,
                        dashRadius: 8,
                      ),

                      itemCount: filteredBranches.length, // Use filtered list
                      itemBuilder: (context, index) {
                        Branch branch = filteredBranches[index];
                        print(branch.anothername);
                        return ListTile(
                          minTileHeight: 10,
                          leading: Text('${index + 1}', style: serialStyle),
                          title: Text('${branch.anothername}',
                              style: infoListStyle),
                          trailing: Text(
                              branch.type == 1
                                  ? "Chi nhánh chính"
                                  : "Chi nhánh phụ",
                              style: labelStyle15),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BranchDetailwidget(branch: branch),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchBranch(String query) {
    setState(() {
      filteredBranches = branches
          .where((branch) =>
              branch.name!.toLowerCase().contains(query.toLowerCase()) ||
              branch.anothername!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
