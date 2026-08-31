import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/rss_dao.dart';
import 'entities/rss_item.dart';

part 'rss_database.g.dart';

@Database(version: 1, entities: [RssItem])
abstract class RssDatabase extends FloorDatabase {
  RssDao get rssDao;
}
