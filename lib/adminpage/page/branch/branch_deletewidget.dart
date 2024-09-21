import 'package:booking_haircut_application/adminpage/page/branch/branch_addwidget.dart';
import 'package:booking_haircut_application/adminpage/page/branch/branch_detailwidget.dart';
import 'package:booking_haircut_application/config/const.dart';
import 'package:booking_haircut_application/data/model/branchmodel.dart';
import 'package:booking_haircut_application/data/provider/branchprovider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class BranchDeleteWidget extends StatefulWidget {
  const BranchDeleteWidget({super.key});

  @override
  State<BranchDeleteWidget> createState() => _BranchDeleteWidgetState();
}

class _BranchDeleteWidgetState extends State<BranchDeleteWidget> {
  final controller = TextEditingController();
  List<Branch> branches = [];
  List<Branch> filteredBranches = []; // Add filteredBranches
  late Future<List<Branch>> listBranch;

  @override
  void initState() {
    super.initState();
    try {
      listBranch = ReadDataBranch().loadData().then((branches) {
        setState(() {
          this.branches = branches;
          filteredBranches = branches; // Initialize filteredBranches
        });
        return branches;
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm kiếm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: searchBranch,
              ),
              const SizedBox(height: 10),
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
                      ).then((_) {
                        // Refresh the branch list after adding a branch
                        _refreshBranchList();
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    iconSize: 25,
                    color: branchColor,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                        itemCount:
                            filteredBranches.length, // Use filteredBranches
                        itemBuilder: (context, index) {
                          Branch branch = filteredBranches[index];
                          return Dismissible(
                              // Use Dismissible for swipe-to-delete
                              key: Key(branch.id!
                                  .toString()), // Unique key for each item
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                _deleteBranch(index);
                              },
                              child: ListTile(
                                minTileHeight: 10,
                                title: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text('${index + 1}',
                                          style: serialStyle),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Text('${branch.anothername}',
                                          style: infoListStyle),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                          branch.type == 1
                                              ? "Chi nhánh chính"
                                              : "Chi nhánh phụ",
                                          style: labelStyle15),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          _deleteBranch(index);
                                        },
                                        child: const Icon(
                                          Icons.do_not_disturb_on_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BranchDetailwidget(branch: branch),
                                    ),
                                  );
                                },
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteBranch(int index) {
    setState(() {
      Branch deletedBranch = filteredBranches.removeAt(index);
      branches.remove(deletedBranch);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa chi nhánh ${branches[index].name}')),
    );
  }

  // Function to refresh the branch list (e.g., after adding or deleting)
  void _refreshBranchList() {
    setState(() {
      listBranch = ReadDataBranch().loadData().then((branches) {
        setState(() {
          this.branches = branches;
          filteredBranches = branches;
        });
        return branches;
      });
    });
  }

  void searchBranch(String query) {
    setState(() {
      filteredBranches = branches
          .where((branch) =>
              branch.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
