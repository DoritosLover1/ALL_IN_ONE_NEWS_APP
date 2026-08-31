// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ntv_feed_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $NtvFeedDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $NtvFeedDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $NtvFeedDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<NtvFeedDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorNtvFeedDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $NtvFeedDatabaseBuilderContract databaseBuilder(String name) =>
      _$NtvFeedDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $NtvFeedDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$NtvFeedDatabaseBuilder(null);
}

class _$NtvFeedDatabaseBuilder implements $NtvFeedDatabaseBuilderContract {
  _$NtvFeedDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $NtvFeedDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $NtvFeedDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<NtvFeedDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$NtvFeedDatabase();
    database.database = await database.open(path, _migrations, _callback);
    return database;
  }
}

class _$NtvFeedDatabase extends NtvFeedDatabase {
  _$NtvFeedDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NtvFeedDao? _ntvFeedDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
          database,
          startVersion,
          endVersion,
          migrations,
        );

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `NtvFeedItem` (`link` TEXT NOT NULL, `title` TEXT NOT NULL, `spot` TEXT, `description` TEXT, `content` TEXT, `pubDate` TEXT, `imageUrl` TEXT, `category` TEXT, `isFavorite` INTEGER NOT NULL, `isRead` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, PRIMARY KEY (`link`))',
        );

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NtvFeedDao get ntvFeedDao {
    return _ntvFeedDaoInstance ??= _$NtvFeedDao(database, changeListener);
  }
}

class _$NtvFeedDao extends NtvFeedDao {
  _$NtvFeedDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database, changeListener),
      _ntvFeedItemInsertionAdapter = InsertionAdapter(
        database,
        'NtvFeedItem',
        (NtvFeedItem item) => <String, Object?>{
          'link': item.link,
          'title': item.title,
          'spot': item.spot,
          'description': item.description,
          'content': item.content,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      ),
      _ntvFeedItemUpdateAdapter = UpdateAdapter(
        database,
        'NtvFeedItem',
        ['link'],
        (NtvFeedItem item) => <String, Object?>{
          'link': item.link,
          'title': item.title,
          'spot': item.spot,
          'description': item.description,
          'content': item.content,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      ),
      _ntvFeedItemDeletionAdapter = DeletionAdapter(
        database,
        'NtvFeedItem',
        ['link'],
        (NtvFeedItem item) => <String, Object?>{
          'link': item.link,
          'title': item.title,
          'spot': item.spot,
          'description': item.description,
          'content': item.content,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NtvFeedItem> _ntvFeedItemInsertionAdapter;

  final UpdateAdapter<NtvFeedItem> _ntvFeedItemUpdateAdapter;

  final DeletionAdapter<NtvFeedItem> _ntvFeedItemDeletionAdapter;

  @override
  Future<List<NtvFeedItem>> findAllNtvFeedItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM NtvFeedItem ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Stream<List<NtvFeedItem>> watchAllNtvFeedItems() {
    return _queryAdapter.queryListStream(
      'SELECT * FROM NtvFeedItem ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      queryableName: 'NtvFeedItem',
      isView: false,
    );
  }

  @override
  Future<NtvFeedItem?> findNtvFeedItemByLink(String link) async {
    return _queryAdapter.query(
      'SELECT * FROM NtvFeedItem WHERE link = ?1 LIMIT 1',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      arguments: [link],
    );
  }

  @override
  Future<List<NtvFeedItem>> findFavoriteNtvFeedItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM NtvFeedItem WHERE isFavorite = 1 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Future<List<NtvFeedItem>> findUnreadNtvFeedItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM NtvFeedItem WHERE isRead = 0 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Future<List<NtvFeedItem>> findNtvFeedItemsByCategory(String category) async {
    return _queryAdapter.queryList(
      'SELECT * FROM NtvFeedItem WHERE category = ?1 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      arguments: [category],
    );
  }

  @override
  Future<List<NtvFeedItem>> searchNtvFeedItems(String query) async {
    return _queryAdapter.queryList(
      'SELECT * FROM NtvFeedItem WHERE title LIKE ?1 OR spot LIKE ?1 OR description LIKE ?1 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => NtvFeedItem(
        link: row['link'] as String,
        title: row['title'] as String,
        spot: row['spot'] as String?,
        description: row['description'] as String?,
        content: row['content'] as String?,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      arguments: [query],
    );
  }

  @override
  Future<int?> getItemCount() async {
    return _queryAdapter.query(
      'SELECT COUNT(*) FROM NtvFeedItem',
      mapper: (Map<String, Object?> row) => row.values.first as int,
    );
  }

  @override
  Future<void> deleteOldUnsavedItems(int cutoffTimestamp) async {
    await _queryAdapter.queryNoReturn(
      'DELETE FROM NtvFeedItem WHERE isFavorite = 0 AND createdAt < ?1',
      arguments: [cutoffTimestamp],
    );
  }

  @override
  Future<void> deleteNtvFeedItemByLink(String link) async {
    await _queryAdapter.queryNoReturn(
      'DELETE FROM NtvFeedItem WHERE link = ?1',
      arguments: [link],
    );
  }

  @override
  Future<void> deleteAllNtvFeedItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM NtvFeedItem');
  }

  @override
  Future<int> insertNtvFeedItem(NtvFeedItem item) {
    return _ntvFeedItemInsertionAdapter.insertAndReturnId(
      item,
      OnConflictStrategy.ignore,
    );
  }

  @override
  Future<List<int>> insertNtvFeedItems(List<NtvFeedItem> items) {
    return _ntvFeedItemInsertionAdapter.insertListAndReturnIds(
      items,
      OnConflictStrategy.ignore,
    );
  }

  @override
  Future<int> updateNtvFeedItem(NtvFeedItem item) {
    return _ntvFeedItemUpdateAdapter.updateAndReturnChangedRows(
      item,
      OnConflictStrategy.abort,
    );
  }

  @override
  Future<int> deleteNtvFeedItem(NtvFeedItem item) {
    return _ntvFeedItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
