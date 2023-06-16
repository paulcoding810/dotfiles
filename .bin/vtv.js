const fetch = require('node-fetch');

const headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/114.0",
    "Accept": "text/html, */*; q=0.01",
    "Accept-Language": "en-US,en;q=0.5",
    "X-Requested-With": "XMLHttpRequest",
    "Alt-Used": "vtvgo.vn",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "Pragma": "no-cache",
    "Cache-Control": "no-cache"
}

function getFormattedDate() {
    const date = new Date()
    var year = date.getFullYear();

    var month = (1 + date.getMonth()).toString();

    var day = date.getDate().toString();
    day = day.length > 1 ? day : '0' + day;

    return year + '/' + month + '/' + day;
}

const parseEpg = (text) =>
    new Promise((resolve, reject) => {
        const matches = text.match(/data-id=\"(\d+).*\n.*\n..*05:30/)
        if (matches.length < 2)
            reject("INVALID " + matches)
        else
            resolve(matches[1])
    })


const loadEpgDetail = (epg_id) => new Promise((resolve, reject) => {
    fetch(`https://vtvgo.vn/ajax-get-epg-detail?epg_id=${epg_id}`, {
        "credentials": "include",
        headers,
        "referrer": "https://vtvgo.vn/xem-truc-tuyen-kenh-vtv1-1.html",
        "method": "GET",
        "mode": "cors"
    })
        .then(res => res.json())
        .then(res => console.log(res.data))
})

fetch(`https://vtvgo.vn/ajax-get-list-epg?selected_date_epg=${getFormattedDate()}&channel_id=1`, {
    "credentials": "include",
    headers,
    "referrer": "https://vtvgo.vn/xem-truc-tuyen-kenh-vtv1-1.html",
    "method": "GET",
    "mode": "cors"
})
    .then(res => res.text())
    .then(parseEpg)
    .then(loadEpgDetail)
    .catch(err => console.error('FAIL', err))

