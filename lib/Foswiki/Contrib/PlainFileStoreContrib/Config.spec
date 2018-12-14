# ---+ Extensions
# ---++ PlainFileStoreContrib
# **BOOLEAN**
# Check before every store modification that there are no suspicious
# files left over from RCS. This check should be enabled whenever there
# is a risk that old RCS data has been mixed in to a PlainFileStore.
$Foswiki::cfg{Extensions}{PlainFileStoreContrib}{CheckForRCS} = 1;

1;
