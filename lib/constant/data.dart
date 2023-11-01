const gridCardData = [
  {"date": "2023-10-31", "askAndGiveCount": 30},
  {"date": "2023-11-01", "askAndGiveCount": 45},
  {"date": "2023-11-02", "askAndGiveCount": 60},
  {"date": "2023-11-03", "askAndGiveCount": 75},
  {"date": "2023-11-04", "askAndGiveCount": 90},
  {"date": "2023-11-05", "askAndGiveCount": 105},
  {"date": "2023-11-06", "askAndGiveCount": 120},
  {"date": "2023-11-07", "askAndGiveCount": 135},
  {"date": "2023-11-08", "askAndGiveCount": 150},
  {"date": "2023-11-09", "askAndGiveCount": 165}
];

const listCardData = [
  {
    "id": 1,
    "date": "8/12/2023",
    "ask":
        "justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie",
    "give":
        "in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices",
    "remark":
        "justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae"
  },
  {
    "id": 2,
    "date": "3/10/2023",
    "ask":
        "sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed",
    "give":
        "ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at",
    "remark":
        "pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non"
  },
  {
    "id": 3,
    "date": "3/31/2023",
    "ask":
        "lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam",
    "give": "congue etiam justo etiam pretium iaculis justo in hac habitasse",
    "remark":
        "est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien"
  },
  {
    "id": 4,
    "date": "10/26/2023",
    "ask":
        "sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum",
    "give":
        "maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc",
    "remark":
        "consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut"
  },
  {
    "id": 5,
    "date": "2/16/2023",
    "ask":
        "interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing",
    "give":
        "dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus",
    "remark":
        "id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada"
  },
  {
    "id": 6,
    "date": "2/3/2023",
    "ask":
        "eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci",
    "give":
        "at turpis a pede posuere nonummy integer non velit donec diam neque",
    "remark":
        "eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper"
  },
  {
    "id": 7,
    "date": "2/25/2023",
    "ask":
        "dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae",
    "give":
        "pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus",
    "remark":
        "in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula"
  },
  {
    "id": 8,
    "date": "3/11/2023",
    "ask":
        "justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus",
    "give":
        "et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum",
    "remark":
        "lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu"
  },
  {
    "id": 9,
    "date": "7/18/2023",
    "ask":
        "sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus",
    "give":
        "vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id",
    "remark":
        "quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis"
  },
  {
    "id": 10,
    "date": "6/30/2023",
    "ask":
        "nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat",
    "give":
        "quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus",
    "remark":
        "at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis"
  },
  {
    "id": 11,
    "date": "12/1/2022",
    "ask":
        "lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante",
    "give":
        "auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis",
    "remark":
        "tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet"
  },
  {
    "id": 12,
    "date": "6/21/2023",
    "ask":
        "mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis",
    "give":
        "nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget",
    "remark":
        "lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus"
  },
  {
    "id": 13,
    "date": "11/23/2022",
    "ask":
        "amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus",
    "give":
        "ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus",
    "remark":
        "odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio"
  },
  {
    "id": 14,
    "date": "9/17/2023",
    "ask": "sapien sapien non mi integer ac neque duis bibendum morbi",
    "give":
        "in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed",
    "remark":
        "sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus"
  },
  {
    "id": 15,
    "date": "7/5/2023",
    "ask":
        "amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu",
    "give":
        "integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor",
    "remark":
        "donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus"
  },
  {
    "id": 16,
    "date": "12/17/2022",
    "ask":
        "eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat",
    "give":
        "magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere",
    "remark":
        "justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est"
  },
  {
    "id": 17,
    "date": "2/22/2023",
    "ask":
        "accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae",
    "give":
        "metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget",
    "remark":
        "donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend"
  },
  {
    "id": 18,
    "date": "2/10/2023",
    "ask":
        "diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque",
    "give":
        "nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo",
    "remark":
        "vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel"
  },
  {
    "id": 19,
    "date": "2/18/2023",
    "ask":
        "tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus",
    "give":
        "pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut",
    "remark":
        "at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non"
  },
  {
    "id": 20,
    "date": "11/27/2022",
    "ask":
        "libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti",
    "give":
        "consequat lectus in est risus auctor sed tristique in tempus sit amet sem",
    "remark":
        "nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc"
  }
];

const personCardData = [
  {
    "_id": 1,
    "name": "Carmelle",
    "email": "cveysey0@google.nl",
    "profileImage": "http://dummyimage.com/174x100.png/ff4444/ffffff",
    "mobileNo": "207-926-1792"
  },
  {
    "_id": 2,
    "name": "Gretel",
    "email": "glambarton1@infoseek.co.jp",
    "profileImage": "http://dummyimage.com/236x100.png/ff4444/ffffff",
    "mobileNo": "352-166-5487"
  },
  {
    "_id": 3,
    "name": "Edie",
    "email": "ebossel2@blogs.com",
    "profileImage": "http://dummyimage.com/224x100.png/ff4444/ffffff",
    "mobileNo": "149-188-7028"
  },
  {
    "_id": 4,
    "name": "Murial",
    "email": "mwortman3@joomla.org",
    "profileImage": "http://dummyimage.com/190x100.png/ff4444/ffffff",
    "mobileNo": "746-946-0728"
  },
  {
    "_id": 5,
    "name": "Celestyna",
    "email": "czuanelli4@goo.ne.jp",
    "profileImage": "http://dummyimage.com/186x100.png/dddddd/000000",
    "mobileNo": "173-803-2899"
  },
  {
    "_id": 6,
    "name": "Clayson",
    "email": "cparmer5@cloudflare.com",
    "profileImage": "http://dummyimage.com/191x100.png/ff4444/ffffff",
    "mobileNo": "489-576-5706"
  },
  {
    "_id": 7,
    "name": "Cy",
    "email": "cstigell6@live.com",
    "profileImage": "http://dummyimage.com/125x100.png/5fa2dd/ffffff",
    "mobileNo": "157-123-4583"
  },
  {
    "_id": 8,
    "name": "Yoshi",
    "email": "yweddeburn7@flickr.com",
    "profileImage": "http://dummyimage.com/135x100.png/dddddd/000000",
    "mobileNo": "383-799-7175"
  },
  {
    "_id": 9,
    "name": "Fidole",
    "email": "flewins8@friendfeed.com",
    "profileImage": "http://dummyimage.com/235x100.png/cc0000/ffffff",
    "mobileNo": "620-699-0673"
  },
  {
    "_id": 10,
    "name": "Claiborne",
    "email": "cseel9@cam.ac.uk",
    "profileImage": "http://dummyimage.com/190x100.png/5fa2dd/ffffff",
    "mobileNo": "215-548-8055"
  },
  {
    "_id": 11,
    "name": "Corrinne",
    "email": "cgranta@51.la",
    "profileImage": "http://dummyimage.com/201x100.png/cc0000/ffffff",
    "mobileNo": "758-785-9530"
  },
  {
    "_id": 12,
    "name": "Taite",
    "email": "tmcquaideb@cdc.gov",
    "profileImage": "http://dummyimage.com/247x100.png/cc0000/ffffff",
    "mobileNo": "550-103-5822"
  },
  {
    "_id": 13,
    "name": "Artemis",
    "email": "aplluc@blogger.com",
    "profileImage": "http://dummyimage.com/116x100.png/5fa2dd/ffffff",
    "mobileNo": "595-203-8417"
  },
  {
    "_id": 14,
    "name": "Vin",
    "email": "vmccrackand@eventbrite.com",
    "profileImage": "http://dummyimage.com/219x100.png/cc0000/ffffff",
    "mobileNo": "471-727-2743"
  },
  {
    "_id": 15,
    "name": "Beatrix",
    "email": "bdullarde@gov.uk",
    "profileImage": "http://dummyimage.com/122x100.png/5fa2dd/ffffff",
    "mobileNo": "701-848-7094"
  },
  {
    "_id": 16,
    "name": "Ainsley",
    "email": "asimmf@pbs.org",
    "profileImage": "http://dummyimage.com/241x100.png/cc0000/ffffff",
    "mobileNo": "650-901-0673"
  },
  {
    "_id": 17,
    "name": "Aloysia",
    "email": "aizaksg@mozilla.com",
    "profileImage": "http://dummyimage.com/181x100.png/ff4444/ffffff",
    "mobileNo": "617-539-6572"
  },
  {
    "_id": 18,
    "name": "Garold",
    "email": "geyesh@woothemes.com",
    "profileImage": "http://dummyimage.com/197x100.png/5fa2dd/ffffff",
    "mobileNo": "733-145-9926"
  },
  {
    "_id": 19,
    "name": "Wit",
    "email": "wgushi@fc2.com",
    "profileImage": "http://dummyimage.com/200x100.png/dddddd/000000",
    "mobileNo": "804-140-7217"
  },
  {
    "_id": 20,
    "name": "Shirl",
    "email": "sshillabeerj@livejournal.com",
    "profileImage": "http://dummyimage.com/231x100.png/5fa2dd/ffffff",
    "mobileNo": "310-838-3862"
  }
];
