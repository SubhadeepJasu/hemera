int main () {
    stdout.printf ("Test Utility\nEnter word: ");
    string? a = stdin.read_line ();
    string[] b = {"calculator", "gimp","melody", "music", "spiceup"};
    int x = Hemera.Core.LevenshteinDistanceSearch.search (b, a);
    stdout.printf ("Index %d\n", x);
    return 0;
}
