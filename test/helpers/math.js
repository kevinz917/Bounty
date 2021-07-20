const convertBigNumberArray = (bigNumberArray) => {
  var array = [];
  for (var i = 0; i < bigNumberArray.length; i++) {
    array.push(bigNumberArray[i].toString());
  }
  return array;
};

module.exports = {
  convertBigNumberArray,
};
