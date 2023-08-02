import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GraphsPage extends StatefulWidget {
  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  Future<List<Graph>> _fetchGraphs() async {
    final response = await http.get(Uri.parse('http://41.220.130.15/graphs/'));
    if (response.statusCode == 200) {
      // The request was successful.
      final jsonData = jsonDecode(response.body);
      List<Graph> graphs = [];
      for (var graphJson in jsonData) {
        graphs.add(Graph.fromJson(graphJson));
      }
      return graphs;
    } else {
      // The request failed.
      throw Exception('Failed to fetch graphs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: FutureBuilder<List<Graph>>(
        future: _fetchGraphs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Graph>? graphs = snapshot.data;
            return ListView.builder(
              itemCount: graphs?.length ?? 0,
              itemBuilder: (context, index) {
                Graph graph = graphs![index];
                return ListTile(
                  title: Text(graph.name),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Graph {
  String id;
  String name;
  String type;
  String data;

  Graph({
    required this.id,
    required this.name,
    required this.type,
    required this.data,
  });

  factory Graph.fromJson(Map<String, dynamic> json) {
    return Graph(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      data: json['data'],
    );
  }
}
