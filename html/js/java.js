//SETTINGS
var moneysign = '$'
var data = null;
var IsLoaded = false;

window.addEventListener('message', function(event) {
    data = event.data;
    if (data.type == "open") {
        var background = document.querySelector('#background');
        background.style.display = 'block';

        var cont = document.querySelector('#container');
        cont.style.display = 'block';
        
        setup();

        if(!IsLoaded) {
            navigation();
            upgrade();
            bank();
            members();
            IsLoaded = true;
        }
    } else if (data.type == "update") {
        setup();
    }
});

function setup() {
    //HOME
    var safename = document.querySelector('#safename span');
    var username = document.querySelector('#username');
    safename.innerHTML = data.gang;
    username.innerHTML = data.username;
    
    //BANK
    var safebalans = document.querySelector('#safebalans p');
    safebalans.innerHTML = parseInt(data.safebalance);
    var cashbalans = document.querySelector('#cashbalans p');
    cashbalans.innerHTML = parseInt(data.cashbalance);

    //MEMBERS
    if(data.gangmembers != null) {
        var membercontainer = document.querySelector('#membercontainer');
        let div = '';
        membercontainer.innerHTML = div;
        data.gangmembers.forEach((option, index) => {
            div += 
            '<div class="member">' +
            '<p id="membername" style="overflow: hidden;">' + data.gangmembers[index].name + '</p>' +
            '<p id="rang">' + data.gangmembers[index].grade.name + '</p>' +
            '<p id="promote" class="bossaction" data-cid='+ data.gangmembers[index].cid +'>' + 'PROMOTE' + '</p>' +
            '<p id="demote" class="bossaction" data-cid='+ data.gangmembers[index].cid +'>' + 'DEMOTE' + '</p>' +
            '<p id="kick" class="bossaction" data-cid='+ data.gangmembers[index].cid +'>' + 'KICK' + '</p>' +
            '</div>';
        });
        membercontainer.innerHTML = div;
    }

    //MEMBERS
    var bankhistory = document.querySelector('#bankhistory');
    let transactions = '';
    bankhistory.innerHTML = transactions;
    data.transactions.forEach((option, index) => {
        if(data.transactions[index].type == 'deposit') {
            transactions += 
            '<div class="history">' +
            '<span id="historyid">'+ data.transactions[index].id +'</span>'+
            '<span id="user">'+ data.transactions[index].name +'</span>'+
            '<span id="amount">+'+ data.transactions[index].amount + moneysign + '</span>'+
            '<span id="time">'+ data.transactions[index].time +'</span>'+
            '</div>';
        } else if(data.transactions[index].type == 'withdraw') {
            transactions += 
            '<div class="history">' +
            '<span id="historyid">'+ data.transactions[index].id +'</span>'+
            '<span id="user">'+ data.transactions[index].name +'</span>'+
            '<span id="amount">-'+ data.transactions[index].amount + moneysign + '</span>'+
            '<span id="time">'+ data.transactions[index].time +'</span>'+
            '</div>';
        }
    });
    bankhistory.innerHTML = transactions;

    //MANAGE
    var upgradealarmlv = document.querySelector('#upgradealarm #lv span');
    upgradealarmlv.innerHTML = data.securitylv + 1;
    var upgradealarmcost = document.querySelector('#upgradealarm #cost');
    upgradealarmcost.innerHTML = data.securityupgrade.cost+moneysign;
    var upgradealarminfo = document.querySelector('#upgradealarm #info');
    upgradealarminfo.innerHTML = data.securityupgrade.info;
    var alarmlevellevel = document.querySelector('#upgradealarm #alarmlevel span');
    alarmlevellevel.innerHTML = data.securitylv;

    var upgradestashlv = document.querySelector('#upgradestash #lv span');
    upgradestashlv.innerHTML = data.stashlv + 1;
    var upgradestashcost = document.querySelector('#upgradestash #cost');
    upgradestashcost.innerHTML = data.stashupgrade.cost+moneysign;
    var upgradestashinfo = document.querySelector('#upgradestash #info');
    upgradestashinfo.innerHTML = data.stashupgrade.slots + ' slots/' + data.stashupgrade.weight + ' weight';
    var upgradestashlevel = document.querySelector('#upgradestash #stashlevel span');
    upgradestashlevel.innerHTML = data.stashlv;
}

function members() {
    var promote = document.querySelector('#promote');
    var demote = document.querySelector('#demote');
    var kick = document.querySelector('#kick');

    kick.addEventListener("click", (e) => {
        e.preventDefault();
        if(data.isgangboss) {
            $.post(`https://flex-gangmenu/kickMember`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                cid: e.target.dataset.cid,
            }));
        }
    });

    promote.addEventListener("click", (e) => {
        e.preventDefault();
        if(data.isgangboss) {
            $.post(`https://flex-gangmenu/promoteMember`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                cid: e.target.dataset.cid,
            }));
        }
    });

    demote.addEventListener("click", (e) => {
        e.preventDefault();
        if(data.isgangboss) {
            $.post(`https://flex-gangmenu/demoteMember`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                cid: e.target.dataset.cid,
            }));
        }
    });
}

function upgrade() {
    var upgradestash = document.querySelector('#upgradestash');
    var upgradealarm = document.querySelector('#upgradealarm');

    upgradestash.addEventListener("click", (e) => {
        e.preventDefault();
        if(data.isgangboss) {
            $.post(`https://flex-gangmenu/upgradeStash`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                cost: data.stashupgrade.cost,
                lv: data.securitylv,
            }));
        }
    });

    upgradealarm.addEventListener("click", (e) => {
        e.preventDefault();
        if(data.isgangboss) {
            $.post(`https://flex-gangmenu/upgradeAlarm`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                cost: data.securityupgrade.cost,
                lv: data.stashlv,
            }));
        }
    });
}

function navigation() {
    var close = document.querySelector('#close');
    var home = document.querySelector('#home');
    var stash = document.querySelector('#stash');
    var bank = document.querySelector('#bank');
    var members = document.querySelector('#members');
    var manage = document.querySelector('#manage');

    var homemenu = document.querySelector('#homemenu');
    var bankmenu = document.querySelector('#bankmenu');
    var membersmenu = document.querySelector('#membersmenu');
    var managemenu = document.querySelector('#managemenu');

    home.addEventListener("click", (e) => {
        e.preventDefault();
        homemenu.style.display = 'grid';
        bankmenu.style.display = 'none';
        membersmenu.style.display = 'none';
        managemenu.style.display = 'none';

        home.classList.add('active');
        bank.classList.remove('active');
        members.classList.remove('active');
        manage.classList.remove('active');
    });

    stash.addEventListener("click", (e) => {
        e.preventDefault();
        closemenu();
        $.post(`https://flex-gangmenu/openStash`, JSON.stringify({
            safeid: data.safeid,
            gang: data.gang,
            stashlv: data.stashlv,
        }));
    });

    bank.addEventListener("click", (e) => {
        e.preventDefault();
        homemenu.style.display = 'none';
        bankmenu.style.display = 'grid';
        membersmenu.style.display = 'none';
        managemenu.style.display = 'none';

        home.classList.remove('active');
        bank.classList.add('active');
        members.classList.remove('active');
        manage.classList.remove('active');
    });

    members.addEventListener("click", (e) => {
        e.preventDefault();
        homemenu.style.display = 'none';
        bankmenu.style.display = 'none';
        membersmenu.style.display = 'grid';
        managemenu.style.display = 'none';

        home.classList.remove('active');
        bank.classList.remove('active');
        members.classList.add('active');
        manage.classList.remove('active');
    });

    manage.addEventListener("click", (e) => {
        e.preventDefault();
        homemenu.style.display = 'none';
        bankmenu.style.display = 'none';
        membersmenu.style.display = 'none';
        managemenu.style.display = 'grid';

        home.classList.remove('active');
        bank.classList.remove('active');
        members.classList.remove('active');
        manage.classList.add('active');
    });

    close.addEventListener("click", (e) => {
        e.preventDefault();
        closemenu();
    });
}

function bank() {
    var deposit = document.querySelector('#managemoney #btn1');
    var withdraw = document.querySelector('#managemoney #btn2');
    var moneyamount = document.querySelector('#moneyamount');

    deposit.addEventListener("click", (e) => {
        e.preventDefault();
        if(moneyamount.value > 0) {
            $.post(`https://flex-gangmenu/depositMoney`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                amount: Math.round(moneyamount.value),
            }));
        }
    });

    withdraw.addEventListener("click", (e) => {
        e.preventDefault();
        if(moneyamount.value > 0) {
            $.post(`https://flex-gangmenu/withdrawMoney`, JSON.stringify({
                safeid: data.safeid,
                gang: data.gang,
                amount: Math.round(moneyamount.value),
            }));
        }
    });
}

document.onkeyup = function (event) {
    const charCode = event.key;
    if (charCode == "Escape") {
        closemenu();
    }
};

function closemenu() {
    $.post(`https://flex-gangmenu/closeMenu`);
    var cont = document.querySelector('#container');
    cont.style.display = 'none';

    var cont = document.querySelector('#background');
    background.style.display = 'none';
}