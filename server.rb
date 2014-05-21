require 'sinatra'
require 'pry'
require 'csv'


def parse_roster(file_path)
  players = []

  CSV.foreach(file_path,headers:true, header_converters: :symbol) do |row|
    players << row.to_hash
  end
  players
end


def find_players_on_team(team, parsed_csv_file)
  all_players = parsed_csv_file

  all_players.select do |player|
    player if player[:team] == team
  end
end

def find_all_players_in_position(position, parsed_csv_file)
  all_players = parsed_csv_file

  all_players.select do |player|
    player[:position] == position
  end
end

def gather_all_teams(parsed_csv_file)
  all_players = parsed_csv_file
  teams = []
  all_players.each do |player|
    teams << player[:team] if !teams.include?(player[:team])
  end
  teams
end

def gather_all_positions(parsed_csv_file)
  all_players = parsed_csv_file
  positions = []
  all_players.each do |player|
    positions << player[:position] if !positions.include?(player[:position])
  end
  positions
end

get '/' do
  parsed_roster = parse_roster('roster.csv')
  @title = "Kickball League"
  @teams = gather_all_teams(parsed_roster)
  @positions = gather_all_positions(parsed_roster)
  erb :index
end

get '/teams/:team' do
  parsed_roster = parse_roster('roster.csv')
  @team = params[:team]
  @title = @team
  @players = find_players_on_team(@team, parsed_roster)
  erb :teams
end

get '/positions/:position' do
  parsed_roster = parse_roster('roster.csv')
  @position = params[:position]
  @title = @position
  @players = find_all_players_in_position(@position, parsed_roster)
  erb :positions
end

get '/:something' do
  @something = params[:something]
  redirect '/'
end

