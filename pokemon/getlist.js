const all = require('./all.json');

all.pokemons.forEach(pokemon => {
  const {pokemon_name , file_name, zukan_id, pokemon_sub_name} = pokemon;
  if(pokemon_sub_name && pokemon_sub_name != '')
    console.log(`https://tw.portal-pokemon.com/play/resources/pokedex${file_name} ${zukan_id}.${pokemon_name}-${pokemon_sub_name}.png`);
  else
    console.log(`https://tw.portal-pokemon.com/play/resources/pokedex${file_name} ${zukan_id}.${pokemon_name}.png`);
})
