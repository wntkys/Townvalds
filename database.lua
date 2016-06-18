function CreateDatabase()
	-- Create tables
	local sqlCreate = {};
	sqlCreate[1] = "CREATE TABLE IF NOT EXISTS towns (town_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, town_name STRING NOT NULL UNIQUE, town_owner STRING NOT NULL UNIQUE, nation_id INTEGER, town_explosions_enabled INTEGER NOT NULL, town_pvp_enabled INTEGER NOT NULL, town_mobs_enabled INTEGER DEFAULT 0)";
	sqlCreate[2] = "CREATE TABLE IF NOT EXISTS townChunks (townChunk_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, town_id INTEGER NOT NULL, owner STRING, chunkX INTEGER NOT NULL, chunkZ INTEGER NOT NULL, world STRING NOT NULL, plot_mobs_enabled INTEGER DEFAULT 2)";
	sqlCreate[3] = "CREATE TABLE IF NOT EXISTS residents (player_uuid STRING NOT NULL PRIMARY KEY UNIQUE, player_name STRING NOT NULL UNIQUE, town_id INTEGER, town_rank STRING, last_online INTEGER)";
	sqlCreate[4] = "CREATE TABLE IF NOT EXISTS nations (nation_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, nation_name STRING NOT NULL UNIQUE, nation_capital INTEGER NOT NULL UNIQUE)"
	sqlCreate[5] = "CREATE TABLE IF NOT EXISTS invitations (invitation_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player_uuid STRING NOT NULL, town_id INTEGER NOT NULL, invitation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP)";

	for key in pairs(sqlCreate) do
		ExecuteStatement(sqlCreate[key]);
	end
end

function ExecuteStatement(sql, parameters)
	local stmt = db:prepare(sql);
	local result;

	if not (parameters == nil) then
		for key, value in pairs(parameters) do
			stmt:bind(key, value);
		end
	end

	local result = {};
	if (sql:match("SELECT")) then
		local x = 1;
		while (stmt:step() == sqlite3.ROW) do
			result[x] = stmt:get_values();
			x = x + 1;
		end
	else
		stmt:step();
	end

	stmt:finalize();

	if (sql:match("INSERT")) then
		result = db:last_insert_rowid();
	end

	if not (result == nil) then
		return result;
	else
		return 0;
	end
end