import 'dart:convert';
import 'package:booking_haircut_application/data/model/receiptmodel.dart';
import 'package:booking_haircut_application/data/model/servicemodel.dart';
import 'package:booking_haircut_application/data/model/servicetypemodel.dart';
import 'package:booking_haircut_application/data/provider/branchserviceprovider.dart';
import 'package:booking_haircut_application/data/provider/customerprovider.dart';
import 'package:booking_haircut_application/data/provider/employeeprovider.dart';
import 'package:booking_haircut_application/data/provider/receiptprovider.dart';
import 'package:booking_haircut_application/data/provider/serviceprovider.dart';
import 'package:booking_haircut_application/data/provider/servicetypeprovider.dart';
import '../model/branch_servicemodel.dart';
import '../model/branchmodel.dart';
import '../model/employeemodel.dart';
import '../model/feedbackmodel.dart';
import '../model/notificationmodel.dart';
import '../model/order_servicemodel.dart';
import '../model/ordermodel.dart';
import '../model/picturemodel.dart';
import '../model/receipt_service.dart';
import '../provider/branchprovider.dart';
import '../provider/orderprovider.dart';
import '../provider/orderserviceprovider.dart';
import '../provider/receiptserviceprovider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/customermodel.dart';
// Import model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_19.db');
    print("Đường dẫn database: $databasePath");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS "customer" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "image" TEXT,
    "name" TEXT,
    "phone" TEXT,
    "email" TEXT,
    "password" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "service" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" INTEGER,
    "name" TEXT,
    "time" INTEGER,
    "price" REAL
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "service_type" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "employee" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "branch" INTEGER,
    "image" TEXT,
    "name" TEXT,
    "nickname" TEXT,
    "email" TEXT,
    "birthday" TEXT,
    "phone" TEXT,
    "gender" INTEGER,
    "state" INTEGER,
    "role" INTEGER
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "branch" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "anothername" TEXT,
    "image" TEXT,
    "address" TEXT,
    "type" INTEGER 
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "receipt" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "branch" INTEGER,
    "customer" INTEGER,
    "employee" INTEGER,
    "name" TEXT,
    "phone" TEXT,
    "tip" REAL,
    "total" REAL,
    "dateCreate" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "order" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "branch" INTEGER,
    "customer" INTEGER,
    "employee" INTEGER,
    "name" TEXT,
    "phone" TEXT,
    "date" TEXT,
    "time" TEXT,
    "note" TEXT,
    "total" REAL,
    "state" INTEGER,
    "dateCreate" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "feedback" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "receipt" INTEGER,
    "rate" INTEGER,
    "content" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "branch_service" (
    "branch" INTEGER,
    "service" INTEGER,
    "price" REAL,
    PRIMARY KEY("branch", "service")
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "receipt_service" (
    "receipt" INTEGER,
    "service" INTEGER,
    "price" REAL,
    PRIMARY KEY("receipt", "service")
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "order_service" (
    "order" INTEGER,
    "service" INTEGER,
    "price" REAL,
    PRIMARY KEY("order", "service")
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "picture" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "employee" INTEGER,
    "image" TEXT
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "notification" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "customer" INTEGER,
    "content" TEXT,
    "dateCreate" TEXT
  );
  ''');
  }

  // ------------------------ THÊM DATA GỐC -------------------------------
  Future<void> LoadBranch() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Branch> branch = await ReadDataBranch().loadDataDB();
    await ReadDataBranch().insertBranchToDB(db, branch);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('branch');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadServiceType() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<ServiceType> servicetype = await ReadDataServiceType().loadDataDB();
    await ReadDataServiceType().insertServiceTypeToDB(db, servicetype);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('service_type');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadService() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Service> service = await ReadDataService().loadDataDB();
    await ReadDataService().insertServiceToDB(db, service);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('service');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadEmployee() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Employee> employee = await ReadDataEmployee().loadDataDB();
    await ReadDataEmployee().insertEmployeeToDB(db, employee);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('employee');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadCustomer() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Customer> customer = await ReadDataCustomer().loadDataDB();
    await ReadDataCustomer().insertCustomerToDB(db, customer);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('customer');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadOrder() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Order> order = await ReadDataOrder().loadDataDB();
    await ReadDataOrder().insertOrderToDB(db, order);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('order');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadReceipt() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Receipt> receipt = await ReadDataReceipt().loadDataDB();
    await ReadDataReceipt().insertReceiptToDB(db, receipt);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('receipt');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadBranchService() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<BranchService> branchService =
        await ReadDataBranchService().loadData();
    await ReadDataBranchService().insertBranchServiceToDB(db, branchService);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('branch_service');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadOrderService() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<OrderService> orderService = await ReadDataOrderService().loadData();
    await ReadDataOrderService().insertOrderServiceToDB(db, orderService);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('order_service');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadReceiptService() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<ReceiptService> receiptService =
        await ReadDataReceiptService().loadData();
    await ReadDataReceiptService().insertReceiptServiceToDB(db, receiptService);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('receipt_service');
    for (var map in maps) {
      print(map);
    }
  }

  // Future<void> LoadPicture() async {
  //   final db = await database;
  //   // Load JSON data and insert into the database
  //   List<Branch> branches = await ReadDataBranch().loadDataDB();
  //   await ReadDataBranch().insertBranchToDB(db, branches);

  //   // Verify data insertion
  //   List<Map<String, dynamic>> maps = await db.query('branch');
  //   for (var map in maps) {
  //     print(map);
  //   }
  // }

  // Future<void> LoadFeedback() async {
  //   final db = await database;
  //   // Load JSON data and insert into the database
  //   List<Branch> branches = await ReadDataBranch().loadDataDB();
  //   await ReadDataBranch().insertBranchToDB(db, branches);

  //   // Verify data insertion
  //   List<Map<String, dynamic>> maps = await db.query('branch');
  //   for (var map in maps) {
  //     print(map);
  //   }
  // }

  // Future addDataForBranch() async {
  //   final db = await database;
  //   await db.insert("branch", {jsonEncode([BranchArray])});
  // }
  // ------------------------ THÊM DATA GỐC -------------------------------

  Future<int> getNextAvailableId(String tableName) async {
    final db = await database;
    List<int> existingIds = [];

    List<Map<String, dynamic>> idList =
        await db.rawQuery('SELECT id FROM $tableName ORDER BY id');
    idList.forEach((element) {
      existingIds.add(element['id']);
    });

    int nextId = 1;
    for (int i = 0; i < existingIds.length; i++) {
      if (existingIds[i] != nextId) {
        break;
      }
      nextId++;
    }

    return nextId;
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Customer
  // ------------------------------------------------------------------
  // Create
  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    int nextId = await getNextAvailableId('customer');
    customer.id = nextId;

    await db.insert('customer', customer.toMap());
  }

  // Read all customers
  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('customer');

    return results.map((map) => Customer.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('customer', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Customer.fromMap(results.first);
    }
    return null;
  }

  // Read customer by ID
  Future<Customer?> getCustomerByPhone(String? phone) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('customer', where: 'phone = ?', whereArgs: [phone]);
    if (results.isNotEmpty) {
      return Customer.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update('customer', customer.toMap(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<void> updateCustomerEPN(Customer customer) async {
    final db = await database;

    // Tạo bản đồ chỉ chứa các trường cần cập nhật
    final updatedFields = <String, dynamic>{
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
    };

    // Xóa các trường null khỏi bản đồ
    updatedFields.removeWhere((key, value) => value == null);

    await db.update(
      'customer',
      updatedFields,
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> updatePassword(Customer customer) async {
    final db = await database;

    // Tạo bản đồ chỉ chứa các trường cần cập nhật
    final updatedFields = <String, dynamic>{
      'password': customer.password,
    };

    // Xóa các trường null khỏi bản đồ
    updatedFields.removeWhere((key, value) => value == null);

    await db.update(
      'customer',
      updatedFields,
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Delete
  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete('customer', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Service type
  // ------------------------------------------------------------------------
  // Create
  Future<void> insertServiceType(ServiceType servicetype) async {
    final db = await database;
    int nextId = await getNextAvailableId('service_type');
    servicetype.id = nextId;

    await db.insert('service_type', servicetype.toMap());
  }

  // Read all customers
  Future<List<ServiceType>> getAllServiceType() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('service_type');

    return results.map((map) => ServiceType.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<ServiceType?> getServiceTypeById(int? id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('service_type', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ServiceType.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateServiceType(ServiceType servicetype) async {
    final db = await database;
    await db.update('service_type', servicetype.toMap(),
        where: 'id = ?', whereArgs: [servicetype.id]);
  }

  // Delete
  Future<void> deleteServiceType(int id) async {
    final db = await database;
    await db.delete('service_type', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Service
  // -------------------------------------------------------------------
  // Create
  Future<void> insertService(Service service) async {
    final db = await database;
    int nextId = await getNextAvailableId('service');
    service.id = nextId;

    await db.insert('service', service.toMap());
  }

  // Read all customers
  Future<List<Service>> getAllService() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('service');

    return results.map((map) => Service.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Service?> getServiceById(int? id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('service', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Service.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateService(Service service) async {
    final db = await database;
    await db.update('service', service.toMap(),
        where: 'id = ?', whereArgs: [service.id]);
  }

  // Delete
  Future<void> deleteService(int id) async {
    final db = await database;
    await db.delete('service', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Branch
  // ------------------------------------------------------------------
  // Create
  Future<void> insertBranch(Branch branch) async {
    final db = await database;
    int nextId = await getNextAvailableId('branch');
    branch.id = nextId;

    await db.insert('branch', branch.toMap());
  }

  // Read all customers
  Future<List<Branch>> getAllBranch() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('branch');

    return results.map((map) => Branch.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Branch?> getBranchById(int? id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('branch', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Branch.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateBranch(Branch branch) async {
    final db = await database;
    await db.update('branch', branch.toMap(),
        where: 'id = ?', whereArgs: [branch.id]);
  }

  // Delete
  Future<void> deleteBranch(int id) async {
    final db = await database;
    await db.delete('branch', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Employee
  // --------------------------------------------------------------------
  // Create
  Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    int nextId = await getNextAvailableId('employee');
    employee.id = nextId;

    await db.insert('employee', employee.toMap());
  }

  // Read all employees
  Future<List<Employee>> getAllEmployee() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('employee');

    return results.map((map) => Employee.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Employee?> getEmployeeById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('employee', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Employee.fromMap(results.first);
    }
    return null;
  }

  Future<List<Employee>> getEmployeesByBranch(int? branchId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'employee',
      where: 'branch = ?',
      whereArgs: [branchId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Employee.fromMap(order)).toList();
    }

    return [];
  }

  // Update
  Future<void> updateEmployee(Employee employee) async {
    final db = await database;
    await db.update('employee', employee.toMap(),
        where: 'id = ?', whereArgs: [employee.id]);
  }

  // Delete
  Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db.delete('employee', where: 'id = ?', whereArgs: [id]);
  }

  // -----------------------------------------------------------------
  // --------------------------------------------------- CRUD of Order
  // -----------------------------------------------------------------
  // Create
  Future<void> insertOrder(Order order) async {
    final db = await database;
    int nextId = await getNextAvailableId('order');
    order.id = nextId;

    await db.insert('order', order.toMap());
  }

  // Read all orders
  Future<List<Order>> getAllOrder() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('order');

    return results.map((map) => Order.fromMap(map)).toList();
  }

  // Get ALL ORDER For EMPLOYEE
  Future<List<Order>> getOrdersByBranch(int? branchId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'order',
      where: 'branch = ?',
      whereArgs: [branchId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Order.fromMap(order)).toList();
    }

    return [];
  }

  // Get ALL ORDER For EMPLOYEE
  Future<List<Order>> getOrdersByEmployee(int? employeeId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'order',
      where: 'employee = ?',
      whereArgs: [employeeId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Order.fromMap(order)).toList();
    }

    return [];
  }

  // Get ALL ORDER For CUSTOMER
  Future<List<Order>> getOrdersByCustomer(int? customerId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'order',
      where: 'customer = ?',
      whereArgs: [customerId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Order.fromMap(order)).toList();
    }

    return [];
  }

  // Read order by ID
  Future<Order?> getOrderById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('order', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Order.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateOrder(Order order) async {
    final db = await database;
    await db
        .update('order', order.toMap(), where: 'id = ?', whereArgs: [order.id]);
  }

  // Cancel order
  Future<void> updateOrderStatus(int orderId) async {
    final db = await database;
    await db.update(
      'order',
      {'state': 0},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  // Delete
  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete('order', where: 'id = ?', whereArgs: [id]);
  }

  // -------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Receipt
  // -------------------------------------------------------------------
  // Create
  Future<Receipt?> insertReceipt(Receipt receipt) async {
    final db = await database;
    int nextId = await getNextAvailableId('receipt');
    receipt.id = nextId;

    // Insert receipt into database and get the ID of the newly inserted row
    int insertedId = await db.insert('receipt', receipt.toMap());

    // Fetch the newly inserted receipt using the inserted ID
    List<Map<String, dynamic>> maps = await db.query(
      'receipt',
      where: 'id = ?',
      whereArgs: [insertedId],
    );

    if (maps.isNotEmpty) {
      return Receipt.fromMap(maps.first);
    } else {
      return null; // or handle the case when no receipt is found
    }
  }

  // Read all receipts
  Future<List<Receipt>> getAllReceipt() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('receipt');

    return results.map((map) => Receipt.fromMap(map)).toList();
  }

  // Read receipt by ID
  Future<Receipt?> getReceiptById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('receipt', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Receipt.fromMap(results.first);
    }
    return null;
  }

  // Get ALL RECEIPT For BRANCH
  Future<List<Receipt>> getReceiptsByBranch(int? branchId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'receipt',
      where: 'branch = ?',
      whereArgs: [branchId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Receipt.fromMap(order)).toList();
    }

    return [];
  }

  // Get ALL RECEIPT For EMPLOYEE
  Future<List<Receipt>> getReceiptsByEmployee(int? employeeId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'receipt',
      where: 'employee = ?',
      whereArgs: [employeeId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Receipt.fromMap(order)).toList();
    }

    return [];
  }

  // Get ALL RECEIPT For CUSTOMER
  Future<List<Receipt>> getReceiptsByCustomer(int? customerId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'receipt',
      where: 'customer = ?',
      whereArgs: [customerId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => Receipt.fromMap(order)).toList();
    }

    return [];
  }

  // Update
  Future<void> updateReceipt(Receipt receipt) async {
    final db = await database;
    await db.update('receipt', receipt.toMap(),
        where: 'id = ?', whereArgs: [receipt.id]);
  }

  // Delete
  Future<void> deleteReceipt(int id) async {
    final db = await database;
    await db.delete('receipt', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Branch_Service
  // --------------------------------------------------------------------------
  // Create
  Future<void> insertBranchService(BranchService branchService) async {
    final db = await database;
    await db.insert('branch_service', branchService.toMap());
  }

  // Read all branches
  Future<List<BranchService>> getAllBranchService() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('branch_service');

    return results.map((map) => BranchService.fromMap(map)).toList();
  }

  Future<List<BranchService>> getServiceByBranch(int? branchId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'branch_service',

      where: 'branch = ?',
      whereArgs: [branchId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => BranchService.fromMap(order)).toList();
    }

    return [];
  }

  // Read branch by ID
  Future<BranchService?> getBranchServiceById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('branch_service', where: 'branch = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return BranchService.fromMap(results.first);
    }
    return null;
  }

  // Read branch by ID
  Future<BranchService?> getBranchServiceByIdService(
      int idService, int idBranch) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('branch_service',
        where: 'branch = ? AND service = ?', whereArgs: [idBranch, idService]);
    if (results.isNotEmpty) {
      return BranchService.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateBranchService(BranchService branchService) async {
    final db = await database;
    await db.update('branch_service', branchService.toMap(),
        where: 'branch = ? AND service = ?',
        whereArgs: [branchService.branch, branchService.service]);
  }

  // Delete
  Future<void> deleteBranchService(BranchService branchService) async {
    final db = await database;
    await db.delete('branch_service',
        where: 'branch = ? AND service = ?',
        whereArgs: [branchService.branch, branchService.service]);
  }

  // -------------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Order_Service
  // -------------------------------------------------------------------------
  // Create
  Future<void> insertOrderService(OrderService orderService) async {
    final db = await database;
    await db.insert('order_service', orderService.toMap());
  }

  // Read all Order service
  Future<List<OrderService>> getAllOrderService() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('order_service');

    return results.map((map) => OrderService.fromMap(map)).toList();
  }

  Future<List<OrderService>> getServiceByOrder(int? orderId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'order_service',
      where: '"order" = ?',
      whereArgs: [orderId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => OrderService.fromMap(order)).toList();
    }

    return [];
  }

  // Read order service by ID
  Future<OrderService?> getOrderServiceById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('order_service', where: 'order = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return OrderService.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateOrderService(OrderService orderService) async {
    final db = await database;
    await db.update('order_service', orderService.toMap(),
        where: 'order = ? AND service = ?',
        whereArgs: [orderService.order, orderService.service]);
  }

  // Delete
  Future<void> deleteOrderService(OrderService orderService) async {
    final db = await database;
    await db.delete('order_service',
        where: 'order = ? AND service = ?',
        whereArgs: [orderService.order, orderService.service]);
  }

  // ---------------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Receipt_Service
  // ---------------------------------------------------------------------------
  // Create
  // Future<void> insertReceiptService(ReceiptService receiptService) async {
  //   final db = await database;
  //   await db.insert('receipt_service', receiptService.toMap());
  // }

  Future<void> insertReceiptService(
      Receipt receipt, List<Service> services) async {
    final db = await database;
    for (Service service in services) {
      var price =
          await getBranchServiceByIdService(service.id!, receipt.branch!);
      ReceiptService receiptService = ReceiptService(
        receipt: receipt.id,
        service: service.id,
        price: price?.price,
      );
      await db.insert('receipt_service', receiptService.toMap());
    }
  }

  // Read all customers
  Future<List<ReceiptService>> getAllReceiptService() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('receipt_service');

    return results.map((map) => ReceiptService.fromMap(map)).toList();
  }

  Future<List<ReceiptService>> getServiceByReceipt(int? receiptId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'receipt_service',
      where: 'receipt = ?',
      whereArgs: [receiptId],
    );

    if (results.isNotEmpty) {
      return results.map((order) => ReceiptService.fromMap(order)).toList();
    }

    return [];
  }

  // Read customer by ID
  Future<ReceiptService?> getReceiptServiceById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db
        .query('receipt_service', where: 'receipt = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ReceiptService.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateReceiptService(ReceiptService receiptService) async {
    final db = await database;
    await db.update('receipt_service', receiptService.toMap(),
        where: 'receipt = ? AND service = ?',
        whereArgs: [receiptService.receipt, receiptService.service]);
  }

  // Delete
  Future<void> deleteReceiptService(ReceiptService branchService) async {
    final db = await database;
    await db.delete('receipt_service',
        where: 'receipt = ? AND service = ?',
        whereArgs: [branchService.receipt, branchService.service]);
  }

  // -------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Picture
  // -------------------------------------------------------------------
  // Create
  Future<void> insertPicture(Picture picture) async {
    final db = await database;
    int nextId = await getNextAvailableId('picture');
    picture.id = nextId;

    await db.insert('picture', picture.toMap());
  }

  // Read all customers
  Future<List<Picture>> getAllPicture() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('picture');

    return results.map((map) => Picture.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Picture?> getPictureById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('picture', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Picture.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updatePicture(Picture picture) async {
    final db = await database;
    await db.update('picture', picture.toMap(),
        where: 'id = ?', whereArgs: [picture.id]);
  }

  // Delete
  Future<void> deletePicture(int id) async {
    final db = await database;
    await db.delete('picture', where: 'id = ?', whereArgs: [id]);
  }

  // --------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Feedback
  // --------------------------------------------------------------------
  // Create
  Future<void> insertFeedback(Feedback feedback) async {
    final db = await database;
    int nextId = await getNextAvailableId('feedback');
    feedback.id = nextId;

    await db.insert('feedback', feedback.toMap());
  }

  // Read all customers
  Future<List<Feedback>> getAllFeedback() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('feedback');

    return results.map((map) => Feedback.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Feedback?> getFeedbackById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('feedback', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Feedback.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateFeedback(Feedback feedback) async {
    final db = await database;
    await db.update('feedback', feedback.toMap(),
        where: 'id = ?', whereArgs: [feedback.id]);
  }

  // Delete
  Future<void> deleteFeedback(int id) async {
    final db = await database;
    await db.delete('feedback', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------------------------------------------------------------
  // --------------------------------------------------- CRUD of Notification
  // ------------------------------------------------------------------------
  // Create
  Future<void> insertNotification(Notification notification) async {
    final db = await database;
    int nextId = await getNextAvailableId('notification');
    notification.id = nextId;

    await db.insert('notification', notification.toMap());
  }

  // Read all customers
  Future<List<Notification>> getAllNotification() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('notification');

    return results.map((map) => Notification.fromMap(map)).toList();
  }

  // Read customer by ID
  Future<Notification?> getNotificationById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('notification', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Notification.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateNotification(Notification receipt) async {
    final db = await database;
    await db.update('notification', receipt.toMap(),
        where: 'id = ?', whereArgs: [receipt.id]);
  }

  // Delete
  Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete('notification', where: 'id = ?', whereArgs: [id]);
  }
  // ------------------------------------------------------------------------
  // --------------------------------------------------- NHUTQUAN
  // ------------------------------------------------------------------------

  // CRUD of Service/////////////////////////////////////////
  Future<List<Service>> listservices() async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service',
      orderBy: 'id DESC', // Sắp xếp theo id giảm dần
    );
    return List.generate(maps.length, (index) => Service.fromMap(maps[index]));
  }

  Future<List<Service>> getServicesByType(int typeId) async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'service',
      where: 'type = ?',
      whereArgs: [typeId],
    );
    return List.generate(maps.length, (index) => Service.fromMap(maps[index]));
  }

  Future<void> insertServiceAdmin(Service service) async {
    final db = await _instance.database;
    print('Inserting ServiceType: ${service.toMap()}');
    await db.insert(
      'service',
      service.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateServiceAdmin(Service service) async {
    final db = await _instance.database;
    // In dữ liệu của ServiceType trước khi chèn
    print('Inserting ServiceType: ${service.toMap()}');

    await db.update(
      'service',
      service.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  Future<void> deleteServiceAdmin(int id) async {
    final db = await _instance.database;
    await db.delete(
      'service',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD of Service type//////////////////////////////////////////
  Future<List<ServiceType>> listservicetypes() async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query('service_type');
    return List.generate(
        maps.length, (index) => ServiceType.fromMap(maps[index]));
  }

  Future<ServiceType> servicetype(int id) async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('service_type', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      throw Exception('Không tìm thấy loại dịch vụ với ID: $id');
    }

    return ServiceType.fromMap(maps[0]);
  }

  Future<String> getServicetypeName(int serviceTypeId) async {
    var servicetype = await _instance.servicetype(serviceTypeId);
    return servicetype.name.toString();
  }

  Future<void> insertServicetypeAdmin(ServiceType type) async {
    final db = await _instance.database;

    await db.insert(
      'service_type',
      type.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateServicetypeAdmin(ServiceType type) async {
    final db = await _instance.database;
    // In dữ liệu của ServiceType trước khi chèn
    print('Inserting ServiceType: ${type.toMap()}');

    await db.update(
      'service_type',
      type.toMap(),
      where: 'id = ?',
      whereArgs: [type.id],
    );
  }

  Future<void> deleteServicetypeAdmin(int id) async {
    final db = await _instance.database;

    // Bắt đầu một giao dịch
    await db.transaction((txn) async {
      // Xóa tất cả các dịch vụ liên quan đến loại dịch vụ
      await txn.delete(
        'service',
        where: 'type = ?',
        whereArgs: [id],
      );

      // Xóa loại dịch vụ
      await txn.delete(
        'service_type',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // CRUD of Branch

  // CRUD of Employee
  Future<List<Employee>> listEmployees() async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query('employee');
    return List.generate(maps.length, (index) => Employee.fromMap(maps[index]));
  }

  Future<Map<String, List<Employee>>> listEmployeesByBranch() async {
    final db = await _instance.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT e.*, b.anothername as branch_name
    FROM employee e
    LEFT JOIN branch b ON e.branch = b.id
    
  ''');

    // Nhóm nhân viên theo tên chi nhánh
    Map<String, List<Employee>> employeesByBranch = {};

    for (var map in maps) {
      final employee = Employee.fromMap(map);
      final branchName = map['branch_name'] as String?;

      if (branchName != null) {
        if (employeesByBranch.containsKey(branchName)) {
          employeesByBranch[branchName]!.add(employee);
        } else {
          employeesByBranch[branchName] = [employee];
        }
      }
    }

    return employeesByBranch;
  }

  Future<void> insertEmployeeAdmin(Employee employee) async {
    final db = await _instance.database;
    print('Inserting ServiceType: ${employee.toMap()}');
    await db.insert(
      'employee',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEmployeeAdmin(Employee employee) async {
    final db = await _instance.database;
    // In dữ liệu của ServiceType trước khi chèn
    print('Inserting ServiceType: ${employee.toMap()}');

    await db.update(
      'employee',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployeeAdmin(int id) async {
    final db = await _instance.database;
    await db.delete(
      'employee',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Branch> branchEmployee(int id) async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('branch', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      throw Exception('Không tìm thấy loại dịch vụ với ID: $id');
    }

    return Branch.fromMap(maps[0]);
  }

  Future<List<Branch>> lisBranchEmployee() async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query('branch');
    return List.generate(maps.length, (index) => Branch.fromMap(maps[index]));
  }

  Future<String> getBranchName(int BranchId) async {
    var branch = await _instance.branchEmployee(BranchId);
    return branch.anothername.toString();
  }

  Future<double> getTotalByEmployee(int employeeId) async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(total) as totalSum
      FROM receipt
      WHERE employee = ?
    ''', [employeeId]);

    if (result.isNotEmpty && result.first['totalSum'] != null) {
      return result.first['totalSum'];
    }
    return 0.0;
  }

  Future<double> getTipByEmployee(int employeeId) async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(tip) as tipSum
      FROM receipt
      WHERE employee = ?
    ''', [employeeId]);

    if (result.isNotEmpty && result.first['tipSum'] != null) {
      return result.first['tipSum'];
    }
    return 0.0;
  }
}
