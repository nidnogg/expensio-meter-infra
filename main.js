// Compare date
const dayHasElapsed = () => {
  const timestamp = new Date('2024-03-04T23:59:59Z');
  const currentDate = new Date();
  console.log(currentDate)
  // Set currentDate to exactly 24 hours ago
  currentDate.setDate(currentDate.getDate() - 1);
  
  // Check if the timestamp is from a day ago or not
  return timestamp >= currentDate
}

// Main routine
fetch('https://raw.githubusercontent.com/nidnogg/expensio-meter/main/data/currency_data.json')
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    console.log(dayHasElapsed(data.meta.last_updated_at));
  })
  .catch(error => {
    console.error('There was a problem fetching the data:', error);
  });
