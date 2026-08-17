# Transcript archive — manifest

The archive itself is untracked here (other people's IP stays off the public repo; see
the publishing note in `../README.md`). This manifest is the committed provenance: every
archived file, its origin, and its SHA-256, so the archive can be rebuilt and verified.
`./fetch.sh` re-downloads the files with stable upstream URLs and verifies every present
file against this list. Files with no stable upstream (auto-generated captions, the
montage) live in the private mirror repo `Tomczik76/principia-transcripts`.

| File | SHA-256 | Origin | Refetch |
|---|---|---|---|
| `hickey-value-of-values-jaxconf-2012.md` | `30c4b6144f7ed6565505c038d8ef0eff7883708b5d21bbaf61d17238bcd01dde` | matthiasn/talk-transcripts, `Hickey_Rich/ValueOfValues-mostly-text.md` (JaxConf 2012) | URL |
| `bailis-feral-concurrency-control-sigmod-2015.pdf` | `97438aa0e5149f719d72d8fadb1cfbf671247acd9e5e7c3831b1265510c0d809` | bailis.org author version (SIGMOD 2015, DOI 10.1145/2723372.2737784) | URL |
| `hughes-how-to-specify-it-tfp2019.pdf` | `125cd575d70272ab4293f507c9c4bc86ce2ed00d138bbf2467888a5d671bb613` | open-access author version, research.chalmers.se/publication/517894 (LNCS 12053) | landing page |
| `bjarnason-constraints-liberate-scala-world-2015.txt` | `11005e72f3bd4a34495e0641f825e92decf2e8a16cbb0bf7b470488c6d6df473` | auto-generated captions; video youtube.com/watch?v=GqmsQeSzMdw (Scala World 2015) | mirror only |
| `bjarnason-composing-programs-scala-exchange-2017.txt` | `67743e84982b284eb7c1e759a83f29128f3b30898b41017731e298a4ba9027a7` | auto-generated captions; Scala eXchange 2017 closing keynote (skillsmatter.com/skillscasts/10746) | mirror only |
| `bjarnason-composing-programs-slides-montage.pdf` | `073f6de530cfb3f1ddc199542a32f3307371110d3639b6afe6af674c34a4b641` | slide/transcript montage by Philip Schwarz | mirror only |
| `ousterhout-philosophy-of-software-design-google-2018.txt` | `5bcf3925e328f71ee935f06cac0c851f20af22de8e546aa2371c28e852305c62` | auto-generated captions; Talks at Google 2018 | mirror only |
| `markbage-minimal-api-surface-area-jsconf-eu-2014.txt` | `2b7cd826e8e3b0036a2621e1c65b739e5589649a30dfdc90730424078b3500fc` | auto-generated captions; JSConf EU 2014 | mirror only |
| `kleppmann-transactions-myths-surprises-opportunities-strange-loop-2015.txt` | `e996fd83a752d7116df1ea46350424988e930e1fcc00b3d8c1c43b8953feabcd` | auto-generated captions; Strange Loop 2015 | mirror only |
| `milewski-profunctor-optics-lambda-world-2017.txt` | `134a92afcc048d9d002de47c8d9681cda04c374cc2bc623be9977ed7544c242e` | auto-generated captions; Lambda World 2017 (Cádiz) | mirror only |
| `wadler-theorems-for-free-fpca-1989.ps` | `b180809e5c4c5b937d6acc7e19d05c7483ff81ca114fdb7e675d3bc18a7304e0` | author's copy, FPCA 1989 | fetch.sh |
| `elliott-denotational-design-type-class-morphisms-2009.pdf` | `8b72780b5fb9056a70cc949b8611defa7bd7146d7b04076ee8e37da941732e24` | author's copy, conal.net, 2009 (2016 revision) | fetch.sh |

Sources cited by URL only, never archived: Hickey *Simple Made Easy* (matthiasn repo),
King *Parse, Don't Validate* (lexi-lambda.github.io), Metz *The Wrong Abstraction*
(sandimetz.com), Welsh *Functional Programming Strategies in Scala with Cats*
(scalawithcats.com — a living book, so a checksum would pin a revision rather than
the work) — see `SOURCES.md` in the archive/mirror.

A checksum mismatch on a refetch means the upstream changed, not that this list is wrong:
diff before overwriting, then update the hash here in the same commit as the new file
lands in the mirror.
