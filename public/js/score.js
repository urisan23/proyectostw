function populateStars (stars, score)
{
    for (var i = 1; i <= 5; i++)
    {
        $('a.star-' + i, stars).removeClass('full');
        $('a.star-' + i, stars).removeClass('half');
        $('li.star-' + i, stars).removeClass('full');
        $('li.star-' + i, stars).removeClass('half');
    }
  
    // Round the score
    score = Math.round(score / 0.5) * 0.5;

    // Get the number of whole stars
    var iWholeStars = Math.floor(score);
    // Do we want a half star?
    var blnHalfStar = (iWholeStars < score);

    // Show the stars
    for (var iStar = 1; iStar <= iWholeStars; iStar++)
    {
        $('a.star-' + iStar, stars).addClass('full');
        $('li.star-' + iStar, stars).addClass('full');
    }

    // And the half star
    if (blnHalfStar)
    {
        $('.star-' + iStar, stars).addClass('half');
    }
}

function puntuacion (score){
  populateStars($('.big-stars'), score)
}