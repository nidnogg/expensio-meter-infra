const fs = require('fs');
const path = require('path');

// File paths
const lastFetchAtPath = '/Users/nidnogg/localdev/expensio-meter/data/last_fetch_at.json';
const currencyDataPath = '/Users/nidnogg/localdev/expensio-meter/data/currency_data.json';

const writeJson = (filePath, fileContent) => {
  fs.writeFile(filePath, fileContent, (err) => {
    if (err) {
      console.error('Error creating file:', err);
      return;
    }
    console.log(`File created successfully at ${filePath}`);
  });
}

const dayHasElapsed = (dateToCheck) => {
  const timestamp = new Date(dateToCheck);
  const currentDate = new Date();
  currentDate.setHours(0, 0, 0, 0);

  return timestamp < currentDate;
}

// Main routine.
fs.readFile(lastFetchAtPath, 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading last fetch date file:', err);
    return;
  }
  
  try {
    const lastFetchAtData = JSON.parse(data);

    if (!dayHasElapsed(lastFetchAtData.date)) { 
      process.exit(1); 
    } else {
      // Fetch currency data
      fetch('https://raw.githubusercontent.com/nidnogg/expensio-meter/main/data/currency_data.json')
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(currencyData => {
          const newLastFetchAtDate = { date: new Date() };
          writeJson(currencyDataPath, JSON.stringify(currencyData, null, 2));
          writeJson(lastFetchAtPath, JSON.stringify(newLastFetchAtDate, null, 2));
          process.exit(0);
        })
        .catch(error => {
          console.error('There was a problem fetching the data:', error);
        });
    }
  } catch (error) {
    console.error('Error parsing last fetch date JSON:', error);
  }
});
