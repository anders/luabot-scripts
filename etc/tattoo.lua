local alphabet = {'月', '官', '匹', '刀', '三', '下', '巨', '升', '工', '丁', '水', '心', '冊', '内', '口', '沢', '百', '手', '本', '気', '七', '新', '人', '山', '父', '子'}
return (arg[1]:gsub('[^%w]+', ''):lower():gsub('%w', function(c) return alphabet[c:byte() - 96] end))
