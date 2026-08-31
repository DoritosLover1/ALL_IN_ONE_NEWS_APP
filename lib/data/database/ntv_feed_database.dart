import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/ntv_feed_dao.dart';
import 'entities/ntv_feed_item.dart';

part 'ntv_feed_database.g.dart';

@Database(version: 1, entities: [NtvFeedItem])
abstract class NtvFeedDatabase extends FloorDatabase {
  NtvFeedDao get ntvFeedDao;
}
