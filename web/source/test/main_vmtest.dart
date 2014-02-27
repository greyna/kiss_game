part of vmtest;

void mainTest()
{
  
  var a, b;
  group('Testing variables value', ()
  {
    setUp(()
    {
      a = 'truc';
      b = 'machin';
    });
    
    tearDown(()
    {
      
    });
    
    test('a contains truc & b contains machin', () {
      expect(a, 'truc');
      expect(b, 'machin'); 
    });

    test("a doesn't contain machin & b doesn't contain truc", () {
      expect(a, isNot('machin'));
      expect(b, isNot('truc')); 
    });
    
  });
}

// replace test or group by solo_test or solo_group to run only this one
// replace test or group by skip_test or skip_group to do not run only this one
// can use filterTests(regexp | predicate | string) to filter by test name