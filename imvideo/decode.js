
const data = process.argv[2];

const json = JSON.parse(data);

json.data.recordings.map(d => {
  console.log(d.video_url + ' ' + d.description);
});

//console.log(JSON.stringify(json));

