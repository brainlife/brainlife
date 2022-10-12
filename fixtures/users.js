const usersBulk = db.users.initializeUnorderedBulkOp();
usersBulk.find({ _id: ObjectId("6307878856fdd79a7cb802c2") }).upsert().updateOne({
  "sub": NumberInt(1),
  "username": "admin",
  "fullname": "Admin User",
  "email": "admin@dev.brainlife.io",
  "email_confirmed": false,
  "profile": {
    "public": {
      "institution": "Brainlife.io"
    },
    "private": {
      "position": "Software Engineer",
      "aup": true
    }
  },
  "password_hash": "",
  "ext": {
    "x509dns": [],
    "openids": []
  },
  "times": {
    "register": ISODate("2022-08-25T14:30:30.408+0000"),
    "local_login": ISODate("2022-08-25T14:40:32.617+0000")
  },
  "scopes": {
    "brainlife": [
      "user",
      "admin",
      "tester"
    ],
    "warehouse": [
      "admin",
      "datatype.create"
    ],
    "amaretti": [
      "admin",
      "resource.create"
    ],
    "auth": [
      "admin"
    ]
  },
  "active": true
});
usersBulk.find({ _id: ObjectId("630ac3b593d38e53bc5cfb06") }).upsert().updateOne({
  "sub": 2,
  "username": "guest",
  "fullname": "Guest User",
  "email": "guest@dev.brainlife.io",
  "email_confirmed": false,
  "profile": {
    "public": {
      "institution": "Brainlife.io"
    },
    "private": {
      "position": "Reaseacher",
      "aup": true
    }
  },
  "password_hash": "",
  "ext": {
    "x509dns": [],
    "openids": []
  },
  "times": {
    "register": ISODate("2022-08-27T21:24:05.288-04:00")
  },
  "scopes": {
    "brainlife": ["user"]
  },
  "active": true,
});
usersBulk.execute();

// Groups
const groupsBulk = db.groups.initializeUnorderedBulkOp();
groupsBulk.find({ _id: ObjectId("6307a3bb6ead0791ce80ff59") }).upsert().updateOne({
  "id": 1,
  "name": "Public Group",
  "desc": "All users should be member of this group",
  "admins": [
    ObjectId("6307878856fdd79a7cb802c2"),
  ],
  "members": [],
  "active": true,
  "create_date": ISODate("2022-08-19T16:02:44.159Z"),
});
groupsBulk.find({ _id: ObjectId("6307878856fdd79a7cb802c2") }).upsert().updateOne({
  "id": 2,
  "name": "Storage Access",
  "desc": "Group used to give access to storage resource",
  "admins": [
    ObjectId("6307878856fdd79a7cb802c2"),
  ],
  "members": [],
  "active": true,
  "create_date": ISODate("2022-08-19T16:02:44.159Z"),
});
groupsBulk.find({ _id: ObjectId("6307910af2bb44794b404759") }).upsert().updateOne({
  "id": 3,
  "name": "Group Analysis Access",
  "desc": "Group used to give access to group analysis server",
  "admins": [
    ObjectId("6307878856fdd79a7cb802c2"),
  ],
  "members": [],
  "active": true,
  "create_date": ISODate("2022-08-19T16:02:44.159Z"),
});
groupsBulk.execute();
