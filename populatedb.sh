#!/bin/bash

set -ex

# Run this script to populate initial set of data needed to run dev instance of brainlife.io

# create test users
docker exec -i brainlife_mongodb mongo <<'EOF'
use auth

const bulk = db.users.initializeUnorderedBulkOp();
bulk.find({_id: ObjectId("6307878856fdd79a7cb802c2")}).upsert().updateOne({
    "sub" : NumberInt(1),
    "username" : "admin",
    "fullname" : "Admin User",
    "email" : "soichih+admin@gmail.com",
    "email_confirmed" : false,
    "profile" : {
        "public" : {
            "institution" : "Indiana University"
        },
        "private" : {
            "position" : "Software Engineer",
            "aup" : true
        }
    },
    "password_hash" : "$2a$10$tOfChShvBRLETjV9FNvNZuYJXX8CoGoQH01pEeO6Nj7zkjnn1Oi3u",
    "ext" : {
        "x509dns" : [ ],
        "openids" : [ ]
    },
    "times" : {
        "register" : ISODate("2022-08-25T14:30:30.408+0000"),
        "local_login" : ISODate("2022-08-25T14:40:32.617+0000")
    },
    "scopes" : {
        "brainlife" : [
            "user",
            "admin",
            "tester"
        ],
        "warehouse" : [
            "admin",
            "datatype.create"
        ],
        "amaretti" : [
            "admin",
            "resource.create"
        ],
        "auth" : [
            "admin"
        ]
    },
    "active" : true
});
bulk.find({_id: ObjectId("630ac3b593d38e53bc5cfb06")}).upsert().updateOne({
  "sub" : 2,
  "username" : "guest",
  "fullname" : "Guest User",
  "email" : "soichih+guest@gmail.com",
  "email_confirmed" : false,
  "profile" : {
    "public" : {
      "institution" : "Indiana University"
    },
    "private" : {
      "position" : "Reaseacher",
      "aup" : true
    }
  },
  "password_hash" : "$2a$10$46AMrp/NwaqzEu3Hy9MpduNM4r7aSjBzKIw.fssB0GyB7ZytGFqTK",
  "ext" : {
    "x509dns" : [ ],
    "openids" : [ ]
  },
  "times" : {
    "register" : ISODate("2022-08-27T21:24:05.288-04:00")
  },
  "scopes" : {
    "brainlife" : [ "user" ]
  },
  "active" : true,
});

bulk.execute();
//db.users.find().pretty();
EOF

# create test groups
docker exec -i brainlife_mongodb mongo <<'EOF'
use auth
const bulk = db.groups.initializeUnorderedBulkOp();
bulk.find({_id: ObjectId("6307a3bb6ead0791ce80ff59")}).upsert().updateOne({
    "id" : 1,
    "name" : "Public Group",
    "desc" : "All users should be member of this group",
    "admins" : [
      ObjectId("6307878856fdd79a7cb802c2"), 
    ],
    "members" : [ ],
    "active" : true,
    "create_date" : ISODate("2022-08-19T16:02:44.159Z"),
});
bulk.find({_id: ObjectId("6307878856fdd79a7cb802c2")}).upsert().updateOne({
    "id" : 2,
    "name" : "Storage Access",
    "desc" : "Group used to give access to storage resource",
    "admins" : [
      ObjectId("6307878856fdd79a7cb802c2"), 
    ],
    "members" : [ ],
    "active" : true,
    "create_date" : ISODate("2022-08-19T16:02:44.159Z"),
});
bulk.find({_id: ObjectId("6307910af2bb44794b404759")}).upsert().updateOne({
    "id" : 3,
    "name" : "Group Analysis Access",
    "desc" : "Group used to give access to group analysis server",
    "admins" : [
      ObjectId("6307878856fdd79a7cb802c2"), 
    ],
    "members" : [ ],
    "active" : true,
    "create_date" : ISODate("2022-08-19T16:02:44.159Z"),
});
bulk.execute();
//db.groups.find().pretty();
EOF

echo "upserting resources"
docker exec -i brainlife_mongodb mongo <<'EOF'
use amaretti
const bulk = db.resources.initializeUnorderedBulkOp();
bulk.find({_id: ObjectId("6307a54b03be04969164c913")}).upsert().updateOne({
    "admins" : [ "1" ],
    "active" : true,
    "name" : "Archiver",
    "avatar" : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeO7o_bA1WCFZ-vj9_oh6knrRXdp2f2_mPhQ&usqp=CAU",
    "config" : {
        "desc" : "A resource used to host data archive",
        "services" : [
            {
                "name" : "brainlife/app-archive",
                "score" : NumberInt(10)
            },
            {
                "name" : "brainlife/app-archive-secondary",
                "score" : NumberInt(10)
            }
        ],
        "maxtask" : "2",
        "ssh_public" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCryGmdEqfxjIJGbjSDWedZiG0lWwvYR0AZqzenGEfv4NvRvmcFiLms0P0fzjeKmfwCtZnYCTCKaorYbr8beEY9uRze3UwM0wMYIXdhC9SfhgRH1ZzJmd1SJYYpI/Y7bXXrmVqYAPYMP8zovIEzHIYP/NpvjInPslQ06aUNlSCs33GlCgMs8BaRrsDsfQCwoAvmkWDRd9kmoR4i+4XdpAwY9SLUa0y+Eyw4mVAD9mb0CSK2Qcklx1q89qV6DOqSoa/pP3NByiKX02oVSagU5hpu4mIvjxOCUzcN5O6PxrOiGvgztxDSljj0tEzYF66umuxdM23q0hTovutCCmgSE7tX ",
        "enc_ssh_private" : "b1096b313dfff06a7bb021fdc66ae6bd9aa714c4992aa13c81de71bdb4e99c85df4139d81d84a05157074aaaf85939a1ee0790c142a16f0bc23524ec9b9430bf166a9a6a9e5426640d1be285030863b25d6bb96fea138949ab8953d4df2384dd0d4894d0216dc8c39efc1c5b953ec2e556e1d4cb69edf465554be5f585f0a2c56a002166bf637dc48c1682a440b42f8e341d6d69653adacaddd6d0dc9718a1936664d878a94bdb70cb821268f82218b083e772a517180233a139253639b56863c05b4962c08b3ac91f8f42f20602ca65ffafbe01c5b36571f044f3be6df9224243f02b52ad027ba4716dec17d0be82455ced4bc52fe154e0a32ab810ddd28a089a7636e3a833e017bc306a509c136349bcec2f22606692973a463291a9a5c702daca45e36a461123fd688044d67d7e80adc64b4556ae456d240c9e719d778b02092e589adff7966518a62a13672740cc339b676d0600479a692f25e6ee510d032e833bd718f78fc5d21c415acdfd9249a9c56b18ec26817483adaf24f80cc17d9206ee734c615d59cf46427dc1792e3fcf32a71b995ac549c57a0afa72da2ba924672deb3b0240e85e2f66b70684403555c0a61e31095eb2b007ca13c86c9709a7f7a4660158972b739bcf686fb491f7d408d166c08028d8ad60b789519b62b52f0f478b8866539e8169666347c1814ed16f6e1b89d0ac96a614991545ca45f21ccc17120b6476b27a33c6a6f15b29d547109f50412d029a33efb5494aecf2628462406674aa776558aa53e7781c0d03ea3576aeb78f87cf5835ffffc16c45074e0b7a0c2a4bce6916b2bd238f76e076e37f80c9a3124450280d42de737da1a84971e5060dd0ca4aeec0e7aba76fa35b1fb2033f246ce8e7b9ecb9a80d13f1b3d07b4cb89b4a21b098a75704856303724375cc2f97f5d8e06031bbb651efc54422e0d12342a974f4f87de883d327255286b8896078f5e50013abb78f3fc25734d2f99b54065eb18e707c96c33c8096e41f4a47d613f907194a86d5b38299ac31cddbbaa3a03038d8840133c5672d96be01dbf3b3a3acc00704baa340e3b430f69a9804da8c310e21949696dba093df8d28ee47d8233885155d888ab85b2d14fdcb25dc32866ea3d703c92085941549356611edbcfb46686a5612bdb92b27965f721260380e246e84dd4b9fbe1b30be21d42596f706afb029cfc7a36e0ba9bf159afbb24ab0918d703dade09310b92a6f97c870721c107aed102957e89751730d75b43d21316a85d8adb991ea3188d266e8c003b628b4e4382187d79173a32d503fb6a183cc4cb4c689663f73f1a4a7d91e6cf89046d705c47e1e2a7cba43900d5978263c576b1b35b5829931ed44d1d2a8f538566c7243c6615f5a9b93a191619a4855eb4b158064774e460c9eaf5742b6e650fa9341d6dc9b61796e8117e1c78559d67e7804065ab6a3884d2c06f838bbc7ceb09c3e0a67c0952042b3d4524f10c6fb1cdae0f88071addba264ad49995a45762400b602917e6512a5c86cf08e08bab34ed46e63fb6b6f0bce314f52752853ddc4dec277cafb982afebf7368f4856b7f545cb2f87f55952b0b870b4b4055221652bef6be441d480c85ed7d7dd54335c8eb0550a7054920a59c393195da08a26b57879ab57b27bd8438e581007f566f0acfb27af997ad9bddec050a43a74fdf49fb7a0ceda0c8425968854846287dcd507f66ca47ff4a5920bfef3d7239251b428a813df5f0aa54c48a5d97eb6142fe9ac5b59883860c25eacee9a9143f75d5eafbbe7b602dbc01698688cbf76f065b19cec601e9c59f53add907469b9ed80fd5098dd97df40bcebe339e26291c85da1702781307f3b9c4f36fba27415193d510c2c32ea951d191ec285edbb8f83bfb2de43e48dcc3346608edfc2838e1f65d7436bf0e52a4fbc21dde76ea94f03a3e46688b2b4c5743b8e20305896dcb1f56dc9295d49869cad66feb3eba35cdbd12379a2d78aee29b34a68223ebe8fa8afc88d240160836a09b5d4ae751d4ad2d502bd26c2bab1d42e6a37c03808bdacd8cf5849b06b35e5e1f2c3e699a6d207ab8a1ff0a2a06388c6c50a9f72454b9cc3318c15e186cdb555d467609ee0e047af37a924d3e1a532ddde161728ed9b4d9a1a0a63fad5f05fff02cbb126578812b60daf1915e506522745a0789b550eb28928431e08a049ab6685ca8c087d2c6f0d00c43c3de7e2cf75f3d8eefa76a169497e60d967ae9dcdc994826a957c466d97b3ac18631fb422ce1291d5d396ba0298bf13912f3ad36fc0792d551b183b2b7073811d2f96eede86f7cf191e4b3aecac8844cb7418a4caf511e69e31d12183e4a06529094294ca2458ba93cdd398f03b7fabb13abed917431cf2ac4a3e0c856a785a09f8667bdf17a1b1f49a69192",
        "username" : "brainlife",
        "hostname" : "brainlife_archive",
        "workdir" : "/archive"
    },
    "envs" : {
        "BRAINLIFE_ARCHIVE_local" : "/archive",
        "SECONDARY_ARCHIVE": "/secondary",
        "BRAINLIFE_NOSMON" : NumberInt(1),
        "BRAINLIFE_CONFIGENCKEY" : "/home/brainlife/.ssh/configEncrypt.key"
    },
    "gids" : [
        NumberInt(2)
    ],
    "stats" : {
        "recent_job_counts" : [ ]
    },
    "create_date" : ISODate("2022-08-25T16:37:31.229+0000"),
    "update_date" : ISODate("2022-08-25T16:37:31.230+0000"),
    "user_id" : "1",
    "status" : "ok",
    "status_msg" : "not tested yet",
    "status_update" : ISODate("2022-08-25T16:37:41.313+0000")
});
bulk.find({_id: ObjectId("6307d234e7498d276ff988db")}).upsert().updateOne({
    "admins" : [ "1" ],
    "active" : true,
    "name" : "Uploader / Validator",
    "avatar" : "https://brainlife.io/docs/img/media/logo_grayback.png",
    "config" : {
        "desc" : "A resource used to handle file upload and data normalization and validation",
        "services" : [
            { "score" : NumberInt(10), "name" : "brainlife/validator-neuro-dwi" },
            { "score" : NumberInt(10), "name" : "brainlife/validator-neuro-anat" },
            { "score" : "10", "name" : "brainlife/validator-neuro-track" },
            { "name" : "soichih/sca-service-noop", "score" : NumberInt(10) },
            { "name" : "soichih/sca-service-conneval-validate", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-func-task", "score" : NumberInt(10) },
            { "name" : "brainlife/app-noop", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-freesurfer", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-rois", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-optometry-oct", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-tractprofile", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-fmap", "score" : NumberInt(10) },
            { "name" : "brainlife/app-bids-import", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-microperimetry", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-network", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-timeseries", "score" : NumberInt(10) },
            { "name" : "brainlife/validator-neuro-tractmeasures", "score" : NumberInt(10) }
        ],
        "maxtask" : NumberInt(1),
        "ssh_public" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC87qQHXDnUl87YrK35Ek0XxUjv+oo0nO/rD1QrhG8Q+I46GvzbvEuJwtnC67dG/VrywHTwgKY1+dZQt6Vg09CWgPGfjot6c70JS4ZdSDNVEtKi80/m5lio+stKRI+QBt1CfySiwDWyoj489MVHkHEawqAXnIurSEDHnkhj1cj+cq5er5xyh2YORUMnmji/DhGoYvdIXLusqM8SU1yz7C66v8F7AgAdlHng4ZY+hoLs3WfrM4DF/OA83Dlix5NtL32F0koo0/Pk25eaQs6X91rLdY88QDRhR0wn/+vULh7lOOsLm2mb2HGPPkXimB3uUFiistYJ7kxn2ho+rA8/EwVN ",
        "enc_ssh_private" : "275ba29cbd144ee1c79a40cde558049ef8255129915e6245b5c9ce40fa42c2d6d1a1da9f5c0828ea071cf26dca130026e3a0092376b98c8a01479729644a1538bc448d0982220166170e26eed649d02ed64ba06a4c570f40e0ce13a453377acdc9ac8f983706308935156bc3756f38d48abe459e0dc88e30d7508ff77ef1b402c42f4414e7969a2124ff647d4ce0afceb3c0b2a774577c8439eaf6d1aa9630f1ca785c197b58542a8c06fbde2b1fc2e3c39c7f46fec09a90f23c2c55bf814304724bda5e352e9f7d547f9c2d10a5a5bc87a53014357263ee47135cb79762f47bbe9b0fd80aded4082947f3439826e39204d6c0740496728865555dfde7395895183b6c3c5bcedd79d7a20c96ccc97352f6901fe51b37c544b9b35899edd06d47336bbff80147950a713eeab9eebd6fc4cb165f1c7c0e5469c5dc560ef3e42b8f9af2d81366a7ce31ae9cfe630d045759f040a96f09663af2a4530784ef1d9b4799053544aeca4338d36b4804ce521303eec4a85ac60829a52c1bc8bbe30caf8ce6798228382b276b8dfc58ba44d084df5e10870cb7ed96fd558669b4c928e355a56f8624adfa2d1f1b01cc1ee9065e6977db2bec22e6eb3fda18480d07819062a54f76312d8e8c03a7fde1fb4867bc2b676515689c435245ec3e8c28bd87c1f130d2e53102ae43bc735747338bf6b416fd872d83c9ae14f462631fb3f9bbb70052c0e9359c023efc7c08729a76963c02a8ac9c65ebcf704c286c479163d9bde6ab455308f41c87f9fce501cb8aab39d72415f6585fd2c3e4f61d6c72f5da640a3690ab5c3213d4ba68c5ce55742ec1a37386d89e581a4753b88452e8ab25246fc8ee5348c7e54b5b38e2012da27f5574986fe1adc0af7e708a8d6d36ef17392ef588183a23f4ff165aa948589298272db15be5cf3709693514b3cc7696fd76cdcce65854838c71e1197c0a52b4652fa7425e4c0b6f370de54bd83ca15748378ed169f46787f224e1ca1e0af3a5b782fbd3d6561e10e484f5c88c29976b3caa929269e34dd599530bd38e36c6b30051f6bec4fbba8bd0d6df5a514a18cf41643029416c8159fb040edf8b862aecf1f1d14ee81c1c8a5782c8b859315d901cbc56c1aa6856dc0ebc53ddda145c2153236ccee9eb74bec6ef00b5e3de8816bf2509f968e0fc5faf9f9fbd2562fa94f5e00fbc3b6c0edaf7b3cf1de219882bdf73d730c5bf48f496b95573f00a0565ef04f6d4f2d66d93dd66a93bd98bf8866e3bbadba8b95132ca9c74c40a093d9a349b414f967238cacab16c08dc8b1dde77f9d410718a17f8a20937c9e6887086f3b8a36b6b4793eb9979b50d7c9c11bc0b964ead558ebdc27a2e5220e2676559d203be3246f63b6b928e04880085c94d757ec19cc3b81f2ab6fda1b98c9e5038d483b28f7f3ab9f838300d7e94fbe13ecb59b6cadaaef163c9c1c730966a5ca55f2cbbf2ebbd5c9e546b2bd8a2beff43a62862b3efbd33b476f368a4db199d287d4368d875eb59bfc057e15d646127a93e068d66a3a3ff67ae9979cf24d94e791d83a799b51e130d5fe4a2618349ce3eef200ad9e841f9c434807153c6215ef943254ce6103c67fd5e4511f790604d3cae0ee52bc24acac4d7b5716266d1230ef34f879e759dd5ff4c2f1d45738febc76e0913937ec4549143ec1965b48815bbc55ba8eec73c35289e85f13299192524b7d713302c353aa749276b58ad3b812d9563dbce1181bbcbf778973c4c4b637e0b4dc0ca057b0e6c7ee7c0ecce05270fc4e718e92cf21565ef8686554783b76a25cb1d13e366435186bb79ed7c9b38d5005399eb9ae1dde5bd319d880eca389f4d0302a2c8b123266391ad7279fd3c785231e367c0879176f035ca7ea9faed3282791065863382d01f726c740109477614c567358c3c46dd48bf59ea674199aec3a4f1a2866622353a783209c6ce8ed90d5d1720cf5d1b00559f0b93d7c6d8c0b639f25f6eccbfe5db8d2182691ddfe839e250a357048844e9c939ab03009178f615db52ac1c7d10537c87c89675aa22bfdfcfa2f4f716e69c81113254f41c2b12a43edee5bc5291820ddbb1427675470772be2b4c601058ee8a564e21c2ef18eae1eca3bc5e066d69cba518a0545b8ca897fa1e4e67eb382437cb940ee746eb2f512572397e3d6d0da9da837248f333364875efb3c26016f31804db5e55e8a1862decbfc41bbb90ccd1795481c58251bc26647bdff2914c03dd5ff4d6d3250129c5ee8cfbe375e98a25befc7be6a004aa9dd014a3425dd4de759b4b3c4d113fc9bb46bb53efa6afba314386268f65a7e8e902b56ec0f20fbd32ee85db755c9f9bb8971737076ce1835d5ee81071e250f1e262b38fe10c994aafc3008b012a8375328556fda84ec3420defd337ee9d86f5289e",
        "username" : "brainlife",
        "hostname" : "brainlife_upload",
        "workdir" : "/upload"
    },
    "envs" : {
        "EZBIDS" : "/ezbids/workdir",
        "BRAINLIFE_NOSMON" : NumberInt(1)
    },
    "gids" : [
        NumberInt(1)
    ],
    "stats" : {
        "recent_job_counts" : [ ]
    },
    "create_date" : ISODate("2022-08-25T19:49:08.197+0000"),
    "update_date" : ISODate("2022-08-25T19:49:08.197+0000"),
    "user_id" : "1",
    "status" : "ok",
    "status_msg" : "not tested yet",
    "status_update" : ISODate("2022-08-25T16:37:41.313+0000")
});
bulk.find({_id: ObjectId("630933e44c93b6d2054ce6a3")}).upsert().updateOne({
  "admins" : [ "1" ],
  "active" : true,
  "name" : "Stager",
  "avatar" : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeO7o_bA1WCFZ-vj9_oh6knrRXdp2f2_mPhQ&usqp=CAU",
  "config" : {
    "desc" : "A resource used for data staging. The server is hosted on the Jetstream and access wrangler through NFS client. 6 threads seems to be max that 6 core wrangler nfs server can handle (secondary: primary: 149.165.156.63 wranger2:149.165.169.130). I had it set to 8 and it killed the primary.. maybe something was wrong with the network?\n\nWith the use of ratermount / autofs, app-stage no longer need to untar anything.. but if the data comes from elsewhere, it still needs to use bl dataset download, etc.. ",
    "services" : [
      {
          "name" : "brainlife/app-stage",
          "score" : NumberInt(10)
      }
    ],
    "maxtask" : 1,
    "ssh_public" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyqJhOJ5hhw3Le9bNpKcKbq4GEUsxqIHqCHFGKCb9di+ecj56FjgxtFGsfmJN3Wg2yKYb+rpwR/8mvEdW+DFhvix7l0y0/858pazgNq5Q8ylhXmi3Qd3EPOE1wPVdRrcRkWEWnEb9eK2gOSNDRQ9c83DQZLHX16EIsltbRhb3RVfTKN4fDV1DwWC9AmemX697MY/piGLeI/Cn1br16G9tHuHm0LXoM9yhOV7a0EsqrzW68Y8x0vPMO/W5nuqn+w7eiuNU6BWj/QDoCdjPxlZILV2b4OVf+SCnsxKtzD9TcSdA4zBe01RTWvhDHKBi97U4D5CHn3DoA2Q4rhVzu88Ex ",
    "enc_ssh_private" : "d958621a193c9c507dffc18c538a6be887299e47aa283bdbaf1ffaaf169a578055ce0abd727c2a2248266bc80fc170f3b27bc6ae1c88d3da36e37b2e8143acde23228811013484f9c47b02491f6e43b96e4487489ec9940f91baf7b7a2454bdb94342d0d456ff6569c7a0d3921b51179835e97c2b10715fd8c636dbddadddda95a6fcdaece28f2feaf53337dae1123fddde99e5571624c0537755472529c05373dff5501e72b45bda8da54e70b6df20433ccb3326416dc16746c9e074455e23c1e5e38298457a736e0fb8996bb6ae8f75421482106f1c76b9ddd62f52a52e841a12b7f3441b3bf756cdf049b8c2bf74c686e2ebe8728dab2348146fc971a532cf6691a3711d62f55b0c4369a791ce5b97d7eee4739c7df8bc474dd5c929f397c24f441865b15bd89e5250d87f3da7c9a37a48d687bc5f7d35e682897fe13e14d3312a2bfc85d17ca9ea791b6f2ce10d76db65dd8fedc303e8ce1f9d364d4f6bb2db3d6f74a8f73d07a10581ede9a6176152057b8a641b21dd3571316b5623758847eed631f3be179592d790111f080d7cb02668dbe6f50a5d34c9463a66d0a1a0cda66a5aa4554347a58623a7377d270581dbfff9c2f041ee8307d9362022d9670789d1635b72c17114c0414d9725e0054e88d3035e01dc3612d42f38218ed702e5cbde6059d755df9c31625ddf8c82861eae72e4da091f1491382282f691b7a2f1241cdd8a3eb6fcd47ed6e50ceb66c845c6fbd093ea8dd3acbef97cb3c3f4336c92b83852857489fd8a3e3b0e6b8736a0cf563b3c5fbc62b8a5926e9f04be0a1edf90ed0727f8f76bf75b1832e956addfdfdf95d1aadc30753f493e05adb836c8afaf893b0e8a9da9879c11fffa8568095cab94a26fee2fc5cdc51174d0eb730496b9d6cd29b80b7db520a076af1125e20ce81017b733c7839d8757da218f4d1dc847336e7c1ed8790e58c2dac415a352dc34bbdd22d45e6f1a24ca4bb8b929ebf94455c5c8315c49e8a89458e6b1ae5f82332cd517386ee7b1922aaa3877f17d622723148c37931c3039176d82eef1a2f563f517632b96252af9a67132589083c52a9aecececc46f70b3f68e9a4dedd55c893f8ebbe25b4191c5411fa90d174a8a381a6e4f6b75b88155da7b64a95babf557e9ce9e0dbb1c0f53331c0dd7a6efb9f8da34086c02fc5e10b3e87318928000760f88e7387b34052dda88bb78d851defbdaad98b566b683d8f6fc13bc0b82dba932cb46e25331353d7708be1ae8bba59f685539d86e0790120e6445bfe785c8abd76eae224c356a80847c43a5656093d72f79c12875d2d58a4c59339655066c96f855c94189faea9bc28fb21ecc14c7e71e9892bf44070cb3ce13d6e29984c66bc564ac94b44a87088ce50c805432c0bb151a82c763bf50d8dfaca1d2153eee8249730bbc832a460ffb82ba0751c49c83b9806948641f4aa6fbba0bf2c378a78c58b942f0d0bdc17b46ec6ee9daef1a2029426a32c990a9129f8e5cc99bcfd8db186f3cc75daf76a2639b68398e83e9c98af6ca4744b19765c0dbe4a0bec498b8ce355351f4b3f08fb6ac4f3449a9924ba01e0267b6d8bfd6344c72f1e2f7de68d5f652569f13f5fbbf599be63e7a40f4001815109f773251c998884da089ee9db9e5b034135643d491acf0b2ee4a936f6e6e07a1ac4c08e5090fb28c123bdaca6ee934956b90d72dd4a0bc907118f86cb0e58e43ac5bed299b80271ed0f8c02088f85af5de82beefeb76b48adfae78408555855b6ba971a920a01241c1daf5d4cbd94c1a2111ee225157574879b38d620f1f4e3602af505c3a70e43165181f301360ce4012dd13491e489127fd3fd03dea9aacde2707186ccdb1b7cfbd1e5c07d3988c1149f3d5543a9c4450cf67f3ff840e9a13c2153d357a958c1185f0bee13784c4e71211edbef18c0b1ccfa90d44bfedc72af299c8e415833238620cc089b69244ced405717915e83f9197388da8f394aa1e40dbbdac8f05efd5eb37ce81b5e1a475bf56030319587b7fe2d2477c66d1b327cb2b79aab99708beb8f4045884cf112e425615b96c73d08c4eb0388debd85c08d97ef80b2c47476d8f076823853a0d441937a73e4fbce2947a5d0c097503c7d8031acb5bcf795c22d459af741a94eb0450848bf8334b4d96f29d51361e1097bd387e1216fb6a5b0fc9cb8b3dfd83e6fb1127ae76ae5f9e5707b2c4c614856a472735a322d54352d77b248d71d7c7f5b68a8812b41894e5e2ba126e2d462db753fe842d3c0e0a403d3281493bb7190ee55a2326d9b1bc7655b1814a2c6ef4eb172b1a739aefcb516479e8ceb9dbeee055bc88e909f2ddad7c221a7a098a172d3f4a11262a1054169c43fcb483c247233848b5b4bd9a4f787f71169d2627e6a8101a591c0a45ec88e9f",
    "username" : "brainlife",
    "hostname" : "brainlife_archive",
    "workdir" : "/stage"
  },
  "envs" : {
    "BRAINLIFE_RATAR_AUTOFS_local" : "/ratar",
    "BRAINLIFE_NOSMON" : 1,
    "BRAINLIFE_CONFIGENCKEY" : "/home/brainlife/.ssh/configEncrypt.key"
  },
  "gids" : [
      NumberInt(2)
  ],
  "stats" : {
    "recent_job_counts" : [ ]
  },
  "create_date" : ISODate("2022-08-26T16:58:12.493-04:00"),
  "update_date" : ISODate("2022-08-26T16:58:12.493-04:00"),
  "user_id" : "1",
  "status" : "ok",
  "status_msg" : "setup by populate script",
  "status_update" : ISODate("2022-08-26T16:58:15.729-04:00")
});
bulk.find({_id: ObjectId("630ac28329c0b4168849e6a6")}).upsert().updateOne({
  "admins" : [ "1" ],
  "active" : true,
  "name" : "Compute (Direct)",
  "avatar" : "",
  "config" : {
    "desc" : "",
    "services" : [
      { "name" : "brainlife/app-freesurfer", "score" : NumberInt(10) },
      { "name" : "brainlife/app-hcp-acpc-alignment", "score" : NumberInt(10) }
    ],
    "maxtask" : 1,
    "ssh_public" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwEmiTH5EPN2fQjwi163j767EmWcia0wPBLG/EIV3t4iVHbWIeY3af79IWHQgsSxLD1kQO94BvLjXoakaJ3MzedS7sGDb+KiAIWX54f36TxWQYrJUiXNddedHxrtbKyPNq+/e+7xFtZ43HELB62v7aV6pWvIaE8abDaWxGaiBZsKQXb/FU9TsK2mMQYeINqeN61R8cT30tXevQJ7eEssgw5j9z+nLNu7pDO8PDVBAJluYITEyUhlA9oCIly6cDEbILOb3x5Jgdr1/XwZoUq1/5PysigPipIdlM6GiFDZzmb7FglskAysLqpjqQ5bf8cz0ogX0S4yeAZ/aGV+DYxgNP ",
    "enc_ssh_private" : "5c1aa61f17d79078e45f604ce83ff57dea41354d230ff1185c8fb718c2dcb2eeb4af99cd1d1db6a6510ceef9ff5c4a88e693461d1a5a54283546d23bfea05a8f7ebf567f3dfa825652599e3538df329643e6624a2c55ba2595b143df4a0450e8bd7406b573af3c0b0a5dcecacb516e61738465f1bdd07a580f558d5b77c84c2832edd9a4e56687deb31a2f8b525bc886c685e587a53d56c6a1921e7e2a30e89949f322f1070a6ef7c878caf416454c7e8f1e265d394eb249656eccfc60207f3bb6a6dfb31b7ece9a571d28378aad00eb9eb04d0eefa521ce38874ccec56054be48ff81fb2dbff504831e48fa77f5fd832c45655cbe4129e5c91a7e57fc0060da9b4370d190d225d920b90495d0b0e85f5ce42f8504ddbd55cbcc1b3b35b9124ae447c0c70adc8c0338f8729e5d5751591887120a8f05126814d474463c16002e0d8e1207337689b5bf2e736b2a973e183f80de02b8b54477db4cf30349794ae2f15c4e919875bcaf70591be94d673d7b7852ed2807e4bbf9a0747bfee29655a92b08372c619cef8d185664755f35a415d89ea3dbea031cc8c669e24179b27528ffecf45fb5a1244affb8d65ca355efd155e26f4ce50fb4c8d91daa67c00c98ca67a2da829b9632a3d805013c6082dd0b607faf469a40f544ab1b46878140b4739f030ca13f4dece8b856422aaac82419ccea7e6104a10c06e0bbe9ecb066c78b1f6edd2ba9c8a0181e710109ae31165ee1bbad8b2d7ef275db42c5a5964e8b1952578db83dfbc17f0eb3112d73b04cf68f348130b175b6a5868bd2e68520d4398f7887a50be5f742f09cdbd783abf29ec2d00af3f705921d273b1130f771e4eff4c853182dd8b23908d707e7e5c3688ee690fbb3fe0fd077e397c5e4f52dde50a442bb9090100149c79311edb9a9ce98f1d26f0d4e698041601ced8137b65f9b97c8803473ebe792969e5f9c7eee20284b887174a1ebedb977e914019a017a3601bba091dbc32b453beeee54ff986d9f77932cf3271d36d3afbb207a5365429fc09e782a37abe0b4548dfccbf0ae63f9006ebab6a6055a254da284e996615c111d41f2af9dd878fd9a8e1469820cefe7bf67589958611ebc64398344f647ccd95a6d18a08eb31e643d505812815424984b033141ab6d167fe04a0800d6d5b2251434d574a0edcd151f46817269d49971ac8d503c4ca49597d21fe90c6275725f972e3b32de1c7df83f423d3998d7ad18e98bfd8d6e83d1fddbab7b935349c2e176436a167f8be58e09bed8bc43964e5e09f6d962eea4c3cbb69afd04da5a05ae3c5e30c102f53df276906b091ea6f7ac6f293d0538da5ae6b3132cab11b0d859d03392ca56ac85cdbb2cddc271c0845cf29918ceb7bba341498ca7f2b743c8b9c3c9b8a358936a8137c3fb2fb59da558c32e88db3167e87f2a05ce41b9ab73ea338abbe0cae18e3eb7f360c33dbbb9c6c1e16ad45a1576aa27dc3c3ded71d93935fb0ae2514e5fe371569eba1ffc88d11fc02ea37a032327af502534aff899eb019c7ef533f930312c27e8d21864f7fd3b4b4e0eb25d4673b97bf9944be151bebb1fb65d8626c7164969a65ae6ab18efd5a2fc3f213aaba1d033b6ad57c03610d147fee04fe006462b4b78da887a81cf443f75edf01d183f71188d4a70ea931e0438673b016115716b2aded0474bc97707b727c4b03ad13b91d6914b7f3f841626911f447bd6ca940e091b3018c822ea3ad66b140370a1950bfb6966ccb03b75a34ee2026e28d33174ed51e3fdee81ca331e632bea1c6d9d180e7f821c343f1c7aec54e81245e05cbaaa05def07b6b0ab934a1a7ee31a938c74559253deb8893b6a235e581b8ee06d11f65526476972bf216e19b3956b89b40ac55d72575eb666c842c6ce757e340d842cd8b1b00d293ddd55fd452a8bc30bed6cdb4d62d4fbb4bb010378562366d717cc7b181aeeb8c991588fb3169b1c29b5655a664acf6c4a2b15b72723a2b91f68d45fb9903e0f533ea5c6c7cfa902217275a6fe485ce9e397225e2c29f8ac2847b0ad4fd187dda6b82e7a6a9f9bec8e3eb06c1701f4fddd47e8c3cf4a78fd115655c17786f3b1580d208f98a39c8734143d898f071f4c28fea3a63e9c353c4097cf89d5d16fa35e86f78e21f0f96d4852130aab2c2ecbed31b1cb3836d4e3bf6f0a6543892118f67839fb482302e6029a6c830eaa321ca109968951dd06f75c7417c5520bb4750c979dbd06a666d591bc98107a0cef7ea98a34f38bf1ff924baa7b76283795a05937a5eef3d58383c35783061f8b6bd4a287d020e68c31050e16041cd2c5082f9820c3950391dcb53f740dfceb2b728038a98c786a8691a16f1a085d63f591283b995dcd85dbeaa5b548a9b30fa5bb072b3b5e5ef4b43b2618afd79db0e5c3044",
    "username" : "brainlife",
    "hostname" : "brainlife_compute",
    "workdir" : "/scratch"
  },
  "gids" : [
        NumberInt(1)
  ],
  "stats" : {
    "recent_job_counts" : [ ]
  },
  "create_date" : ISODate("2022-08-27T21:18:59.879-04:00"),
  "update_date" : ISODate("2022-08-27T21:18:59.879-04:00"),
  "user_id" : "1",
  "status" : "ok",
  "status_msg" : "setup by populate script",
  "status_update" : ISODate("2022-08-27T21:19:02.521-04:00")
});

bulk.find({_id: ObjectId("631a844d03e55d25180d2873")}).upsert().updateOne({
    "admins" : [
        "1"
    ],
    "active" : true,
    "name" : "Visualization Server",
    "avatar" : "",
    "config" : {
        "desc" : "Server used to run novnc service",
        "services" : [
            {
                "name" : "brainlife/abcd-novnc",
                "score" : NumberInt(10)
            }
        ],
        "maxtask" : NumberInt(4),
        "ssh_public" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHHeKXEw4rFkIUORcxq5g0qkA5Qh/MWfuSjDpkIrTv0b3nzyeXmDw+2QjgN7ufSsBmBsHkZDRmUg8KzmpCw8EqqDXG7GmK9Rxv1pbxHf3rmHPE2LeOAWvrfp6m1yrV9y6aGLSu/At5Gxlus3IDts+qKeWN5wXlvV/uFbq7BNmXlHEuyou3tFeslKTVB/TsF1Pzu72eA+yoUxZkN3Vg+ovMnf9AyiDRLMXEYTeeUXuuqXmKZJc+BKfm4nOydXB/fvnNcQoe09xGH+WLwV3AOkwDXgzkiKAiJddIfGNeg7p9c7w2LYDjQQUL8/q6gxTEQD+6sGsj734HZJPghuclHCpR ",
        "enc_ssh_private" : "3b27a370fb219a7f8b67bce54a050fd701ca2ebb3db1ab85065f5d2167b5b6fe6c4d566c36f67a9ad45e9e25f8468c2b986975f382da825d3c14269aea8abd1b4cfb78eee54ab30ff3f413b18bd55da10a2056aa9052a95cd479c726503c432be84612dcc20464c083ab3bac3b1a273f54afb4de3ef04f645cf90b11f9fbe5127cb7d6c1e1af9c6ca4cbf0097f33b0bc905da3cca45b00c28826ea7ea30b8665067a94023325b056a9b5ff7f5293b6262a24708b5ed8457b9039aa9ef18208904a3c5ddab2029e2736b44ce26d3374b3ed5b862a0cc9d2f3449f30b98d1add9ea0f9b388dd21e5b8fec9e04e735bb76fb3932bea2f7a997dbc74d6351a9ae050576cabf41adb424f9d4d02fd1d6c10a231f98c0e2419f985f2fb10a99d86f5ff541aacb07486b93454e3d8f8795859b1185f22bc57ef681386d28b286f796b20b76533bc18121da6b9e2761a60a05ae69135c6fa31b6d8386d113045decd313339b153beace85385f662ded0ae37f36a1003cdc8bc151188ebb750b82e344947df6a455130eb70be5e982a1b9ed9eab751671016b6dfdb98ddb56c73b3241d6da566d5f4343dd7889e34ced9696790b724572d8ea3aa43b6722c98546f69af074dc15cf0a7dbbc12d7774464eb0e1768196c5c1aed4eb91d0aaa6313a11733b29e74541eda71ae04b2a47e9134bdd5e15b6aa13fc557cd1d8fd2186e662f7a77b0d5612cf1d592a2cbcd7d95039dacb7fa570e9489e47665546909fb72b5b6ba28e4a3c16671db2254952b84b3b4f4c4bd4e7518f4472fd3c080f1a421ee242a347354ebf717c611ce4703abe304f3f313bf97ee525c20b2f85befc552b17059969408ef6edb4b11dead13356735610ae0f30f0638626a37cec4dd3dd9c5179d4fddf36bf288fd336627256034dfff8467c75c92275ebfdb2d4c83f130c7698d4ef0108d312a00cc680e88feba1b1aa4f17a278cca4e12edd599851d03d9dd47e8e7650ae945a23d2abea2e948c20c700a06610dde89dedce15e2c4e1712682f3b2a2a721a1bd198c0e8705d649d6727d1217de8fce85d87b5388e944a62f53cba8e2e17b582e11d8cd242c298b4e8c6e89171c3d3423e6fe8d8a174e619abf2619e96e99462c50a8d9b03cc70bc72a478783768a03d75f1c9ff719414c9f6d051b460326ad2be67b4193700fbc09f2b8fc0b66ec24330b2a38bb24e21a9de75c712b5ffeda18b3ecf3420dad806a37f222c35b5c215835d70f9ecc97bb7bc85f1a2b53eb6a8ae28fdc197361e5901290fe5c905e357d022f923aecbd8974988c3373bc9841205254debd4a75703ff12a60a278d371d070d0f7be03829390f8d20fa057882f6a64222f1e86488faea701e7c8706432b44c1cca276e739a912435e2a1af1e2a500edbeb25f602327308104b3dfa1f68f2b928bb06de7091fae7b1e7d74841a54919f10cfd860567f6980d38a76ff6887b5e66cbe72cb3a3293bb092d15ed5f32edc81ee725b1e0f36c4253c6f2d5bf77de9ddca8dbcd2e30ae412ad6f6066101a8ad5b654ef501837dabb356cfe87d781dcabef69f83ede7b6d428c3f279936a646a9cf3c29ea7661137c8d6e02050a0d5689bccf50746f9c99f5f18aa3371b7140b3b1ed01f3eef069731c7eb8d68a87b1b772d3454fd93b7130245779799886c5ec0966fdeb31cccc8ad1edcc9eaef0629426febf1c4ae7a7084626b2860dbd1e42aedef22136eb556d1260bd301977a269af1d00bf026433025d61d4ec15222e0a1f63203e3cbbc9a0072242532845e29f8e80f098e4facb49341b8f98452ae21e8aa77620e35ca8bc963e585fe50ef6f19c55e7885f52dbe10729c8668aef17dc114f7642c6dd66bee8f09d035f6efd41991d3f05f4c2e8d1ae3e4a2a6549f4f7b06ebc3d1d1d47f0081e3c485a5a93704c5b87b725a20371a971280d3ead05e4b49b4c7ef882788f5eb5eae3cef154719791e2ac3b6a502fe1ad949a03a9feb100266f3c912f72adce3afb2f90b965e0b0d872ac24e52e10a41bce57de340f512ed90ef0dc2d5d6163195d25746131d349ca6739ed0df0c03a5f959b88f6f4a8e69052fa7ccad3d1291fa6bebc1359f4a7c00a86dbabd3f6ac63913e43d7ec8c1e9c93c7a37836b389466fec12eca076c781aefabb52c56f26cedf5f4a0398eb9a3abc8b1af93e388231e1faf57346a49decb11353d28b775a0e407546e080ed3eb9df4909231b62fc6dbb0a4da2a8e973d4bfe5ffc7505688bbe0c224666fb76f2473b719010fc141c4d8c22c19be8da39158d3c17ecd86c32977176a11427a9d12656582eab59b962c4fe1bb9e0d3f6ae2184d6d4960ced9013329b22127ada30781bbd747e6661e264dbb87d3e1cf39a26049d0dfa1882c0b8742149c7538371f6b39ea258fa",
        "username" : "root",
        "hostname" : "brainlife_vis",
        "workdir" : "/scratch"
    },
    "gids" : [
        NumberInt(1)
    ],
    "stats" : {
        "recent_job_counts" : [

        ]
    },
    "create_date" : ISODate("2022-09-09T00:09:49.474+0000"),
    "update_date" : ISODate("2022-09-09T00:09:49.474+0000"),
    "user_id" : "1",
    "status" : "ok",
    "status_msg" : "setup by populate script",
    "status_update" : ISODate("2022-09-09T00:16:57.592+0000")
});

bulk.execute();

db.resources.find().pretty();
EOF

#loading content from db dump (need content in dbdump)
docker exec brainlife_mongodb rm -rf /tmp/dump
docker cp dbdump brainlife_mongodb:/tmp/dump
docker exec brainlife_mongodb mongorestore /tmp/dump
