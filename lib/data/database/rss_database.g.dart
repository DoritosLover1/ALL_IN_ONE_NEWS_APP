// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $RssDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $RssDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $RssDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<RssDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorRssDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $RssDatabaseBuilderContract databaseBuilder(String name) =>
      _$RssDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $RssDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$RssDatabaseBuilder(null);
}

class _$RssDatabaseBuilder implements $RssDatabaseBuilderContract {
  _$RssDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $RssDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $RssDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<RssDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$RssDatabase();
    database.database = await database.open(path, _migrations, _callback);
    return database;
  }
}

class _$RssDatabase extends RssDatabase {
  _$RssDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RssDao? _rssDaoInstance;

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
          'CREATE TABLE IF NOT EXISTS `RssItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sourceId` TEXT NOT NULL, `sourceTitle` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT, `content` TEXT, `link` TEXT NOT NULL, `pubDate` TEXT, `imageUrl` TEXT, `category` TEXT, `author` TEXT, `isFavorite` INTEGER NOT NULL, `isRead` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL)',
        );

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RssDao get rssDao {
    return _rssDaoInstance ??= _$RssDao(database, changeListener);
  }
}

class _$RssDao extends RssDao {
  _$RssDao(this.database, this.changeListener)
    : _queryAdapter = QueryAdapter(database, changeListener),
      _rssItemInsertionAdapter = InsertionAdapter(
        database,
        'RssItem',
        (RssItem item) => <String, Object?>{
          'id': item.id,
          'sourceId': item.sourceId,
          'sourceTitle': item.sourceTitle,
          'title': item.title,
          'description': item.description,
          'content': item.content,
          'link': item.link,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'author': item.author,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      ),
      _rssItemUpdateAdapter = UpdateAdapter(
        database,
        'RssItem',
        ['id'],
        (RssItem item) => <String, Object?>{
          'id': item.id,
          'sourceId': item.sourceId,
          'sourceTitle': item.sourceTitle,
          'title': item.title,
          'description': item.description,
          'content': item.content,
          'link': item.link,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'author': item.author,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      ),
      _rssItemDeletionAdapter = DeletionAdapter(
        database,
        'RssItem',
        ['id'],
        (RssItem item) => <String, Object?>{
          'id': item.id,
          'sourceId': item.sourceId,
          'sourceTitle': item.sourceTitle,
          'title': item.title,
          'description': item.description,
          'content': item.content,
          'link': item.link,
          'pubDate': item.pubDate,
          'imageUrl': item.imageUrl,
          'category': item.category,
          'author': item.author,
          'isFavorite': item.isFavorite ? 1 : 0,
          'isRead': item.isRead ? 1 : 0,
          'createdAt': item.createdAt,
        },
        changeListener,
      );

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RssItem> _rssItemInsertionAdapter;

  final UpdateAdapter<RssItem> _rssItemUpdateAdapter;

  final DeletionAdapter<RssItem> _rssItemDeletionAdapter;

  @override
  Future<List<RssItem>> findAllRssItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM RssItem ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Stream<List<RssItem>> watchAllRssItems() {
    return _queryAdapter.queryListStream(
      'SELECT * FROM RssItem ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      queryableName: 'RssItem',
      isView: false,
    );
  }

  @override
  Future<RssItem?> findRssItemById(int id) async {
    return _queryAdapter.query(
      'SELECT * FROM RssItem WHERE id = ?1',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      arguments: [id],
    );
  }

  @override
  Future<RssItem?> findRssItemByLink(String link) async {
    return _queryAdapter.query(
      'SELECT * FROM RssItem WHERE link = ?1 LIMIT 1',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
      arguments: [link],
    );
  }

  @override
  Future<List<RssItem>> findFavoriteRssItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM RssItem WHERE isFavorite = 1 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Future<List<RssItem>> findUnreadRssItems() async {
    return _queryAdapter.queryList(
      'SELECT * FROM RssItem WHERE isRead = 0 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
        isFavorite: (row['isFavorite'] as int) != 0,
        isRead: (row['isRead'] as int) != 0,
        createdAt: row['createdAt'] as int?,
      ),
    );
  }

  @override
  Future<List<RssItem>> searchRssItems(String query) async {
    return _queryAdapter.queryList(
      'SELECT * FROM RssItem WHERE title LIKE ?1 OR description LIKE ?1 ORDER BY createdAt DESC',
      mapper: (Map<String, Object?> row) => RssItem(
        id: row['id'] as int?,
        sourceId: row['sourceId'] as String,
        sourceTitle: row['sourceTitle'] as String,
        title: row['title'] as String,
        description: row['description'] as String?,
        content: row['content'] as String?,
        link: row['link'] as String,
        pubDate: row['pubDate'] as String?,
        imageUrl: row['imageUrl'] as String?,
        category: row['category'] as String?,
        author: row['author'] as String?,
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
      'SELECT COUNT(*) FROM RssItem',
      mapper: (Map<String, Object?> row) => row.values.first as int,
    );
  }

  @override
  Future<void> deleteOldUnsavedItems(int cutoffTimestamp) async {
    await _queryAdapter.queryNoReturn(
      'DELETE FROM RssItem WHERE isFavorite = 0 AND createdAt < ?1',
      arguments: [cutoffTimestamp],
    );
  }

  @override
  Future<void> deleteRssItemById(int id) async {
    await _queryAdapter.queryNoReturn(
      'DELETE FROM RssItem WHERE id = ?1',
      arguments: [id],
    );
  }

  @override
  Future<void> deleteAllRssItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM RssItem');
  }

  @override
  Future<int> insertRssItem(RssItem item) {
    return _rssItemInsertionAdapter.insertAndReturnId(
      item,
      OnConflictStrategy.replace,
    );
  }

  @override
  Future<List<int>> insertRssItems(List<RssItem> items) {
    return _rssItemInsertionAdapter.insertListAndReturnIds(
      items,
      OnConflictStrategy.replace,
    );
  }

  @override
  Future<int> updateRssItem(RssItem item) {
    return _rssItemUpdateAdapter.updateAndReturnChangedRows(
      item,
      OnConflictStrategy.abort,
    );
  }

  @override
  Future<int> deleteRssItem(RssItem item) {
    return _rssItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
