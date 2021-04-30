import 'package:charts/CompanyOverview.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CompanyList extends StatefulWidget {
  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  late Future<List<Company>> futureCompanies;

  // TODO: Implement error handling
  // Note: Dio > http
  Future<List<Company>> fetchCompanies() async {
    List<Company> companies = [];

    var dio = Dio();
    final res = await dio.get(
        'https://financialmodelingprep.com/api/v3/nasdaq_constituent?apikey=${env['FMP_API_KEY']}');

    if (res.statusCode == 200) {
      final data = res.data as List;
      for (var i = 0; i < data.length; i++) {
        companies.add(new Company.fromJson(data, i));
      }
    }

    return companies;
  }

  // fetch NASDAQ companies list in init State
  @override
  void initState() {
    super.initState();
    futureCompanies = fetchCompanies();
  }

  void tabHandler(String symbol) {
    print(symbol);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyOverview(symbol: symbol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Company>>(
        future: futureCompanies,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final company = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        leading: Text(company.symbol),
                        title: Text(company.name),
                        subtitle: Text(company.symbol),
                        onTap: () => {
                          tabHandler(company.symbol),
                        },
                      ),
                    );
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

// stores the information of a company
class Company {
  final String symbol;
  final String name;
  final String sector;

  Company({required this.symbol, required this.name, required this.sector});

  factory Company.fromJson(List<dynamic> json, int index) => Company(
        symbol: json[index]['symbol'],
        name: json[index]['name'],
        sector: json[index]['sector'],
      );
}
