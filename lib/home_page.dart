import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/team.dart';

class HomePage extends StatelessWidget {
  List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
        name: eachTeam['name'],
      );
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(title: const Text("Stats App",),shadowColor: Colors.transparent,),
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: FutureBuilder(
            future: getTeams(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: teams.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          textColor: Colors.black,
                          title: Text(teams[index].abbreviation),
                          subtitle: Text(teams[index].city),
                          trailing: Text(teams[index].name),

                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}